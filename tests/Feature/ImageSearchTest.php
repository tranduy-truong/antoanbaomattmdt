<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Support\Facades\Http;
class ImageSearchTest extends TestCase
{
    private function png(): string {
        return 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=';
    }
    public function test_invalid_image_never_calls_provider(): void {
        Http::fake();
        $this->postJson('/api/mobile/search/image', ['image'=>'invalid'])->assertStatus(422);
        Http::assertNothingSent();
    }
    public function test_missing_key_is_reported(): void {
        config(['services.gemini.key'=>null]);
        Http::fake();
        $this->postJson('/api/mobile/search/image', ['image'=>$this->png()])->assertStatus(503);
        Http::assertNothingSent();
    }
    public function test_recognizes_unlabelled_pumpkin(): void {
        config(['services.gemini.key'=>'test-key']);
        Http::fake(['generativelanguage.googleapis.com/*'=>Http::response([
            'candidates'=>[['content'=>['parts'=>[['text'=>'{"query":"bí đỏ"}']]]]]
        ])]);
        $this->postJson('/api/mobile/search/image', ['image'=>$this->png()])
            ->assertOk()->assertJson(['query'=>'bí đỏ']);
        Http::assertSent(fn ($request) => $request->hasHeader('x-goog-api-key','test-key')
            && $request['contents'][0]['parts'][1]['inline_data']['data'] === $this->png());
    }
    public function test_unrecognized_image_returns_empty_query(): void {
        config(['services.gemini.key'=>'test-key']);
        Http::fake(['*'=>Http::response(['candidates'=>[['content'=>['parts'=>[['text'=>'{"query":""}']]]]]])]);
        $this->postJson('/api/mobile/search/image', ['image'=>$this->png()])->assertOk()->assertJson(['query'=>'']);
    }
    public function test_provider_failure_does_not_expose_details(): void {
        config(['services.gemini.key'=>'test-key']);
        Http::fake(['*'=>Http::response(['error'=>'private-provider-details'],429)]);
        $this->postJson('/api/mobile/search/image', ['image'=>$this->png()])
            ->assertStatus(503)->assertDontSee('private-provider-details');
    }
}
