-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th4 26, 2026 lúc 10:59 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `vinmark`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cart_items`
--

CREATE TABLE `cart_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `cart_items`
--

INSERT INTO `cart_items` (`id`, `user_id`, `product_id`, `quantity`, `created_at`, `updated_at`) VALUES
(15, 8, 2, 2, '2026-04-11 09:09:59', '2026-04-11 09:09:59');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `image`, `created_at`, `updated_at`) VALUES
(1, 'Rau củ', 'rau-cu', 'Các loại rau củ tươi ngon hàng ngày', 'uploads/categories/1775537866_69d48ecac4956.jpg', '2026-01-28 03:33:29', '2026-04-07 04:57:46'),
(2, 'Trái cây', 'trai-cay', 'Trái cây trong nước & nhập khẩu', 'uploads/categories/1775537950_69d48f1e65d57.jpg', '2026-01-28 03:33:29', '2026-04-07 04:59:10'),
(3, 'Thịt heo', 'thit-heo', 'Thịt heo tươi ngon, đảm bảo vệ sinh an toàn thực phẩm', 'uploads/categories/1775537919_69d48effb32ef.jpg', '2026-01-28 03:33:29', '2026-04-07 04:58:39'),
(4, 'Thịt bò', 'thit-bo', 'Thịt bò tươi, giàu dinh dưỡng, thích hợp cho nhiều món ăn', 'uploads/categories/1775537893_69d48ee5ed16d.jpg', '2026-01-28 03:33:29', '2026-04-07 04:58:13'),
(5, 'Thịt gà & gia cầm', 'thit-ga-gia-cam', 'Thịt gà, vịt, và các loại gia cầm khác tươi sống mỗi ngày', 'uploads/categories/1775537906_69d48ef2529cd.jpg', '2026-01-28 03:33:29', '2026-04-07 04:58:26'),
(6, 'Cá & hải sản', 'ca-hai-san', 'Cá biển, cá nước ngọt, hải sản tươi sống', 'uploads/categories/1775537737_69d48e491a570.jpg', '2026-01-28 03:33:29', '2026-04-07 04:55:37'),
(7, 'Trứng', 'trung', 'Trứng gà, trứng vịt, trứng cút', 'uploads/categories/1775537963_69d48f2baa17f.jpg', '2026-01-28 03:33:29', '2026-04-07 04:59:23'),
(8, 'Đồ hộp & thực phẩm chế biến', 'do-hop-thuc-pham-che-bien', 'Thực phẩm chế biến, đồ hộp, mì, cháo, giấy ăn,…', 'uploads/categories/1775538011_69d48f5b91248.jpg', '2026-01-28 03:33:29', '2026-04-07 05:00:11'),
(9, 'Gạo & ngũ cốc', 'gao-ngu-coc', 'Gạo các loại, ngũ cốc, bột mì, bột gạo', 'uploads/categories/1775537771_69d48e6b5852d.jpg', '2026-01-28 03:33:29', '2026-04-07 04:56:11'),
(10, 'Thực phẩm đông lạnh', 'thuc-pham-dong-lanh', 'Sản phẩm đông lạnh như cá viên, tôm, đậu,…', 'uploads/categories/1775537940_69d48f144a306.jpg', '2026-01-28 03:33:29', '2026-04-07 04:59:00'),
(11, 'Gia vị & dầu ăn', 'gia-vi-dau-an', 'Gia vị, nước mắm, dầu ăn, mù tạt, muối,…', 'uploads/categories/1775537761_69d48e61597ec.webp', '2026-01-28 03:33:29', '2026-04-07 04:56:01'),
(12, 'Gia dụng & đồ dùng nhà bếp', 'gia-dung-do-dung-nha-bep', 'Dụng cụ nấu ăn, chén bát, chảo, hộp đựng,…', 'uploads/categories/1775537750_69d48e565e9f8.jpg', '2026-01-28 03:33:29', '2026-04-07 04:55:50'),
(13, 'Đồ uống & thực phẩm chức năng', 'do-uong-thuc-pham-chuc-nang', 'Nước ngọt, trà, cà phê, thực phẩm bổ sung,…', 'uploads/categories/1775538023_69d48f6757dcf.jpg', '2026-01-28 03:33:29', '2026-04-07 05:00:23'),
(14, 'Bánh kẹo & snack', 'banh-keo-snack', 'Bánh ngọt, kẹo, bim bim, snack, socola và các loại đồ ăn vặt', 'uploads/categories/1775537217_69d48c41e8af0.webp', '2026-01-28 03:33:29', '2026-04-07 04:46:57'),
(15, 'Mì, cháo, phở ăn liền', 'mi-chao-pho-an-lien', 'Các loại mì gói, cháo, phở, bún ăn liền tiện lợi', 'uploads/categories/1775537839_69d48eafc88f3.jpg', '2026-01-28 03:33:29', '2026-04-07 04:57:19'),
(16, 'Nước giải khát có cồn', 'nuoc-giai-khat-co-con', 'Bia, rượu vang, nước trái cây lên men và đồ uống có cồn', 'uploads/categories/1775537851_69d48ebb18451.jpg', '2026-01-28 03:33:29', '2026-04-07 04:57:31'),
(17, 'Đồ dùng vệ sinh nhà cửa', 'do-dung-ve-sinh-nha-cua', 'Nước rửa chén, nước lau sàn, bột giặt, giấy vệ sinh,…', 'uploads/categories/1775537999_69d48f4f7d5dc.jpg', '2026-01-28 03:33:29', '2026-04-07 04:59:59'),
(18, 'Chăm sóc mẹ & bé', 'cham-soc-me-be', 'Sữa bột, tã, khăn ướt, và sản phẩm chăm sóc mẹ & bé', 'uploads/categories/1775537726_69d48e3e596de.jpg', '2026-01-28 03:33:29', '2026-04-07 04:55:26'),
(19, 'Sản phẩm mùa lễ', 'san-pham-mua-le', 'Bánh Trung Thu, quà Tết, giỏ quà, đặc sản vùng miền,…', 'uploads/categories/1775537880_69d48ed8b8b29.jpg', '2026-01-28 03:33:29', '2026-04-07 04:58:00'),
(20, 'Thực phẩm chay', 'thuc-pham-chay', 'Đậu hũ, chả chay, thực phẩm chay ăn liền và đồ chay khô', 'uploads/categories/1775537930_69d48f0a3c80c.jpg', '2026-01-28 03:33:29', '2026-04-07 04:58:50'),
(21, 'Khác', 'khac', 'Các loại thực phẩm & sản phẩm khác', 'uploads/categories/1775537826_69d48ea2b4402.jpg', '2026-01-28 03:33:29', '2026-04-07 04:57:06');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chat_messages`
--

CREATE TABLE `chat_messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `guest_token` varchar(100) DEFAULT NULL,
  `sender` enum('user','bot') NOT NULL DEFAULT 'user',
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `chat_messages`
--

INSERT INTO `chat_messages` (`id`, `user_id`, `guest_token`, `sender`, `message`, `created_at`, `updated_at`) VALUES
(1, 8, NULL, 'user', 'Tôi muốn mua rau', '2026-01-28 03:27:37', '2026-01-28 03:49:07'),
(2, 8, NULL, 'bot', 'Xin lỗi, tôi đang bận.', '2026-01-28 03:27:37', '2026-01-28 03:49:07'),
(3, 8, NULL, 'user', 'hi', '2026-01-28 03:35:16', '2026-01-28 03:49:07'),
(4, 8, NULL, 'bot', 'Xin lỗi, tôi đang bận.', '2026-01-28 03:35:16', '2026-01-28 03:49:07'),
(5, 8, NULL, 'user', 'hi', '2026-01-28 03:49:14', '2026-01-28 03:49:14'),
(6, 8, NULL, 'bot', 'Xin lỗi, tôi đang bận.', '2026-01-28 03:49:14', '2026-01-28 03:49:14'),
(7, 8, NULL, 'user', 'chào', '2026-01-28 03:57:41', '2026-01-28 03:57:41'),
(8, 8, NULL, 'bot', 'Xin lỗi, tôi đang bận.', '2026-01-28 03:57:41', '2026-01-28 03:57:41'),
(9, 8, NULL, 'user', 'hi', '2026-01-28 03:57:44', '2026-01-28 03:57:44'),
(10, 8, NULL, 'bot', 'Xin lỗi, tôi đang bận.', '2026-01-28 03:57:44', '2026-01-28 03:57:44'),
(11, 8, NULL, 'user', 'hi', '2026-01-28 03:59:15', '2026-01-28 03:59:15'),
(12, 8, NULL, 'bot', 'Xin lỗi, tôi đang bận.', '2026-01-28 03:59:15', '2026-01-28 03:59:15'),
(13, 8, NULL, 'user', 'hi', '2026-04-07 04:37:14', '2026-04-07 04:37:14'),
(14, 8, NULL, 'bot', 'Lỗi kết nối AI (Code: 403)', '2026-04-07 04:37:15', '2026-04-07 04:37:15'),
(15, 8, NULL, 'user', 'hi', '2026-04-07 04:37:16', '2026-04-07 04:37:16'),
(16, 8, NULL, 'bot', 'Lỗi kết nối AI (Code: 403)', '2026-04-07 04:37:16', '2026-04-07 04:37:16'),
(17, 8, NULL, 'user', 'hi', '2026-04-07 05:51:15', '2026-04-07 05:51:15'),
(18, 8, NULL, 'bot', 'Lỗi kết nối AI (Code: 403)', '2026-04-07 05:51:16', '2026-04-07 05:51:16'),
(19, 8, NULL, 'user', 'chào', '2026-04-07 11:46:16', '2026-04-07 11:46:16'),
(20, 8, NULL, 'bot', 'Lỗi kết nối AI (Code: 403)', '2026-04-07 11:46:16', '2026-04-07 11:46:16'),
(21, 8, NULL, 'user', 'chào', '2026-04-07 11:51:50', '2026-04-07 11:51:50'),
(22, 8, NULL, 'bot', 'Chào bạn! Vinmark xin chào. Bạn cần tìm mua rau củ hay trái cây gì không ạ?', '2026-04-07 11:51:53', '2026-04-07 11:51:53'),
(23, 8, NULL, 'user', 'chào', '2026-04-07 11:51:53', '2026-04-07 11:51:53'),
(24, 8, NULL, 'bot', ' Chào bạn! Vinmark xin chào. Bạn cần tìm mua rau củ hay trái cây gì không ạ? Chào bạn! Vinmark xin chào. Bạn cần tìm mua rau củ hay trái cây gì không ạ?', '2026-04-07 11:52:08', '2026-04-07 11:52:08'),
(25, 8, NULL, 'user', 'chào', '2026-04-07 11:52:08', '2026-04-07 11:52:08'),
(26, 8, NULL, 'bot', 'Lỗi hệ thống.', '2026-04-07 11:52:38', '2026-04-07 11:52:38'),
(27, 8, NULL, 'user', 'Mình cần mua cá', '2026-04-07 11:52:38', '2026-04-07 11:52:38'),
(28, 8, NULL, 'bot', 'Lỗi kết nối AI (Code: 503)', '2026-04-07 11:52:39', '2026-04-07 11:52:39'),
(29, 8, NULL, 'user', 'Mình cần mua cá', '2026-04-07 11:52:39', '2026-04-07 11:52:39'),
(30, 8, NULL, 'bot', ' - Vui lòng thử lại sau giây lát!', '2026-04-07 11:52:53', '2026-04-07 11:52:53'),
(31, 8, NULL, 'user', 'Mình cần mua cá', '2026-04-07 11:52:53', '2026-04-07 11:52:53'),
(32, 8, NULL, 'bot', 'Lỗi hệ thống.', '2026-04-07 11:53:23', '2026-04-07 11:53:23'),
(33, 8, NULL, 'user', 'mình cần mua cá', '2026-04-07 11:53:24', '2026-04-07 11:53:24'),
(34, 8, NULL, 'bot', 'Dạ, hiện tại Vinmark chưa có mặt hàng cá ạ. Bên mình đang có sẵn rất nhiều rau củ và trái cây tươi ngon, bạn tham khảo thử nhé!', '2026-04-07 11:53:47', '2026-04-07 11:53:47'),
(35, 8, NULL, 'user', 'mình cần mua cá', '2026-04-07 11:53:47', '2026-04-07 11:53:47'),
(36, 8, NULL, 'bot', 'Lỗi kết nối AI (Code: 503)', '2026-04-07 11:53:48', '2026-04-07 11:53:48'),
(37, 8, NULL, 'user', 'chào', '2026-04-07 11:54:14', '2026-04-07 11:54:14'),
(38, 8, NULL, 'bot', 'Vinmark xin chào! Bạn cần tìm mua rau củ hay trái cây tươi gì cho hôm nay không ạ? Mình luôn sẵn sàng hỗ trợ bạn!', '2026-04-07 11:54:43', '2026-04-07 11:54:43'),
(39, 8, NULL, 'user', 'chào', '2026-04-07 11:54:43', '2026-04-07 11:54:43'),
(40, 8, NULL, 'bot', '\nLỗi kết nối AI (Code: 503)', '2026-04-07 11:54:59', '2026-04-07 11:54:59'),
(41, 8, NULL, 'user', 'chào', '2026-04-07 11:54:59', '2026-04-07 11:54:59'),
(42, 8, NULL, 'bot', 'Chào bạn! Vinmark xin chào ạ. Bạn cần tìm mua rau củ hay trái cây tươi gì cho hôm nay không? Mình luôn sẵn sàng hỗ trợ bạn!', '2026-04-07 11:55:14', '2026-04-07 11:55:14'),
(43, 8, NULL, 'user', 'chào', '2026-04-07 11:55:14', '2026-04-07 11:55:14'),
(44, 8, NULL, 'bot', '', '2026-04-07 11:55:33', '2026-04-07 11:55:33'),
(45, 8, NULL, 'user', 'chào', '2026-04-07 11:55:34', '2026-04-07 11:55:34'),
(46, 8, NULL, 'bot', 'Chào bạn! Vinmark rất vui được hỗ trợ. Bạn cần tìm mua rau củ hay trái cây tươi gì hôm nay không ạ?', '2026-04-07 11:56:03', '2026-04-07 11:56:03'),
(47, 8, NULL, 'user', 'chào', '2026-04-07 11:56:04', '2026-04-07 11:56:04'),
(48, 8, NULL, 'bot', 'Lỗi hệ thống.', '2026-04-07 11:56:34', '2026-04-07 11:56:34'),
(49, 8, NULL, 'user', 'mình muốn mua kiwi', '2026-04-07 11:56:34', '2026-04-07 11:56:34'),
(50, 8, NULL, 'bot', 'Lỗi hệ thống.', '2026-04-07 11:57:05', '2026-04-07 11:57:05'),
(51, 8, NULL, 'user', 'mình muốn mua kiwi', '2026-04-07 11:57:05', '2026-04-07 11:57:05'),
(52, 8, NULL, 'bot', '', '2026-04-07 11:57:22', '2026-04-07 11:57:22'),
(53, 8, NULL, 'user', 'mình muốn mua kiwi', '2026-04-07 11:57:22', '2026-04-07 11:57:22'),
(54, 8, NULL, 'user', 'chào', '2026-04-10 03:03:26', '2026-04-10 03:03:26'),
(55, 8, NULL, 'bot', 'Chào bạn! Kiwi xanh tại Vinmark có giá là 110,000đ/kg ạ. Bạn muốn mua bao nhiêu kg để mình chuẩn bị?', '2026-04-10 03:03:37', '2026-04-10 03:03:37'),
(56, 8, NULL, 'user', 'chào', '2026-04-10 03:03:37', '2026-04-10 03:03:37'),
(57, 8, NULL, 'bot', '', '2026-04-10 03:03:39', '2026-04-10 03:03:39'),
(58, 8, NULL, 'user', 'có bán cải thìa không ?', '2026-04-10 03:03:58', '2026-04-10 03:03:58'),
(59, 8, NULL, 'bot', 'Dạ có ạ! Cải thìa tại Vinmark có giá 15,000đ/bó. Bạn muốn lấy mấy bó ạ?', '2026-04-10 03:04:01', '2026-04-10 03:04:01'),
(60, 8, NULL, 'user', 'mình lấy 3 bó', '2026-04-10 03:04:11', '2026-04-10 03:04:11'),
(61, 8, NULL, 'bot', 'Dạ vâng, 3 bó cải thìa của bạn hết 45,000đ ạ. Bạn có muốn mua thêm gì nữa không?', '2026-04-10 03:04:13', '2026-04-10 03:04:13'),
(62, 8, NULL, 'user', 'cải thìa với cải ngọt cái nào ngon hơn ?', '2026-04-10 03:05:35', '2026-04-10 03:05:35'),
(63, 8, NULL, 'bot', 'Dạ, mỗi loại đều có vị ngon riêng ạ! Cải thìa giòn, ngọt thanh, rất hợp để xào; còn cải ngọt thì mềm và ngọt, nấu canh rất ngon. \n\nCải ngọt đang có giá 14,000đ/bó, bạn có muốn lấy thêm vài bó không ạ?', '2026-04-10 03:05:49', '2026-04-10 03:05:49'),
(64, 8, NULL, 'user', 'có cải cay không ?', '2026-04-10 03:11:42', '2026-04-10 03:11:42'),
(65, 8, NULL, 'bot', 'Dạ hiện tại Vinmark không có cải cay rồi ạ. Bạn tham khảo dùng thử **cải thìa (15,000đ/bó)** hoặc **cải ngọt (14,000đ/bó)** cũng rất ngon và tươi ạ! Bạn có muốn lấy thêm loại nào không?', '2026-04-10 03:11:46', '2026-04-10 03:11:46'),
(66, 8, NULL, 'user', 'muốn nấu lẩu nấm thì mua gì ?', '2026-04-10 03:12:18', '2026-04-10 03:12:18'),
(67, 8, NULL, 'bot', 'Lỗi kết nối AI (Code: 503)', '2026-04-10 03:12:20', '2026-04-10 03:12:20'),
(68, 8, NULL, 'user', 'muốn nấu lẩu thì nên mua gì ?', '2026-04-10 03:12:32', '2026-04-10 03:12:32'),
(69, 8, NULL, 'bot', 'Chào bạn, để nấu lẩu ngon, Vinmark gợi ý bạn các loại rau củ tươi có sẵn sau đây:\n\n- **Rau nhúng:** Rau muống (10k/bó), Cải thìa (15k/bó), Cải ngọt (14k/bó), Bắp cải trắng (20k/bắp).\n- **Nấu nước dùng:** Cà chua (25k/kg), Cà rốt (22k/kg), Hành tây (20k/kg) để nước thêm ngọt thanh.\n\nBạn muốn lấy những loại nào để mình soạn đơn cho bạn ạ?', '2026-04-10 03:12:39', '2026-04-10 03:12:39'),
(70, 8, NULL, 'user', 'Cải thìa bao nhiêu tiền ?', '2026-04-11 09:07:19', '2026-04-11 09:09:59'),
(71, 8, NULL, 'bot', 'Chào bạn, cải thìa tại Vinmark có giá 15.000đ/bó ạ! Bạn cần mua mấy bó nhỉ?', '2026-04-11 09:07:25', '2026-04-11 09:09:59'),
(72, 8, NULL, 'user', 'Tôi muốn nấu lẩu thì cần mua rau gì ?', '2026-04-11 09:08:17', '2026-04-11 09:09:59'),
(73, 8, NULL, 'bot', 'Lỗi hệ thống.', '2026-04-11 09:08:48', '2026-04-11 09:09:59'),
(74, 8, NULL, 'user', 'Tôi muốn nấu lẩu thì cần mua rau gì ?', '2026-04-11 09:08:48', '2026-04-11 09:09:59'),
(75, 8, NULL, 'bot', ' Vui lòng thử lại.\n', '2026-04-11 09:08:53', '2026-04-11 09:09:59'),
(76, 8, NULL, 'user', 'Tôi muốn nấu lẩu thì cần mua rau gì ?', '2026-04-11 09:09:00', '2026-04-11 09:09:59'),
(77, 8, NULL, 'bot', 'Chào bạn, để nấu lẩu ngon, Vinmark gợi ý bạn các loại rau sau:\n\n*   **Rau nhúng lẩu:** Rau muống (10.000đ/bó), Cải thìa (15.000đ/bó), Cải ngọt (14.000đ/bó), Bắp cải trắng (20.000đ/bắp).\n*   **Nấu nước dùng:** Cà chua (25.000đ/kg), Cà rốt (22.000đ/kg), Hành tây (20.000đ/kg).\n\nBạn muốn đặt mua những loại nào để Vinmark chuẩn bị cho mình ạ?', '2026-04-11 09:09:23', '2026-04-11 09:09:59');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `contacts`
--

CREATE TABLE `contacts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `message` text NOT NULL,
  `is_replyed` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `contacts`
--

INSERT INTO `contacts` (`id`, `full_name`, `email`, `phone_number`, `message`, `is_replyed`, `created_at`, `updated_at`) VALUES
(1, 'TRẦN DUY TRƯỜNG', 'leanh26191@gmail.com', '0335064110', 'xin chào', 1, '2026-04-07 06:16:53', '2026-04-07 06:17:11');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2025_09_26_025512_create_roles_table', 1),
(2, '2025_09_26_025637_create_permissions__table', 1),
(3, '2025_09_26_025717_create_roles_permissions_table', 1),
(4, '2025_09_26_025818_create_users_table', 1),
(5, '2025_09_26_025925_create_categories_table', 1),
(6, '2025_09_26_025937_create_products_table', 1),
(7, '2025_09_26_030013_create_shipping_addresses_table', 1),
(8, '2025_09_26_030113_create_orders_table', 1),
(9, '2025_09_26_030127_create_order_items_table', 1),
(10, '2025_09_26_030200_create_payments_table', 1),
(11, '2025_09_26_030219_create_wishlists_table', 1),
(12, '2025_09_26_030233_create_notifications_table', 1),
(13, '2025_09_26_030248_create_contacts_table', 1),
(14, '2025_09_26_030317_create_order_status_history_table', 1),
(15, '2025_09_26_030335_create_cart_items_table', 1),
(16, '2025_09_26_030520_create_reviews_table', 1),
(17, '2025_09_26_030630_create_product_images_table', 1),
(18, '2025_09_26_030715_create_password_reset_token_tables', 1),
(19, '2025_12_20_150916_create_chat-messages_table', 1),
(20, '2026_01_28_102522_create_sessions_table', 2);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `shipping_address_id` bigint(20) UNSIGNED NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `shipping_address_id`, `total_price`, `status`, `created_at`, `updated_at`) VALUES
(16, 8, 1, 50000.00, 'pending', '2026-04-07 11:32:00', '2026-04-07 11:32:00'),
(17, 8, 1, 43000.00, 'completed', '2026-04-07 11:38:46', '2026-04-07 11:39:16'),
(18, 8, 1, 45000.00, 'completed', '2026-04-07 11:44:55', '2026-04-07 11:45:35');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders_status_history`
--

CREATE TABLE `orders_status_history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('pending','processing','shipped','completed','cancelled') NOT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price`, `created_at`, `updated_at`) VALUES
(10, 16, 5, 1, 25000.00, '2026-04-07 11:32:00', '2026-04-07 11:32:00'),
(11, 17, 8, 1, 18000.00, '2026-04-07 11:38:46', '2026-04-07 11:38:46'),
(12, 18, 9, 1, 20000.00, '2026-04-07 11:44:55', '2026-04-07 11:44:55');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `payment_method` enum('paypal','cash','momo','vnpay') NOT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `paid_at` datetime DEFAULT NULL,
  `status` enum('pending','completed','failed') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `payments`
--

INSERT INTO `payments` (`id`, `order_id`, `payment_method`, `transaction_id`, `amount`, `paid_at`, `status`, `created_at`, `updated_at`) VALUES
(2, 16, 'vnpay', NULL, 50000.00, NULL, 'pending', '2026-04-07 11:32:00', '2026-04-07 11:32:00'),
(3, 17, 'vnpay', '15486133', 43000.00, '2026-04-07 18:39:16', 'completed', '2026-04-07 11:38:46', '2026-04-07 11:39:16'),
(4, 18, 'vnpay', '15486138', 45000.00, '2026-04-07 18:45:35', 'completed', '2026-04-07 11:44:55', '2026-04-07 11:45:35');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'manage_users', '2026-01-28 03:33:26', '2026-01-28 03:33:26'),
(2, 'manage_products', '2026-01-28 03:33:26', '2026-01-28 03:33:26'),
(3, 'manage_orders', '2026-01-28 03:33:26', '2026-01-28 03:33:26'),
(4, 'manage_categories', '2026-01-28 03:33:26', '2026-01-28 03:33:26'),
(5, 'manage_contacts', '2026-01-28 03:33:26', '2026-01-28 03:33:26');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `status` varchar(255) NOT NULL DEFAULT 'in_stock',
  `unit` varchar(255) DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `name`, `slug`, `description`, `price`, `stock`, `status`, `unit`, `category_id`, `created_at`, `updated_at`) VALUES
(1, 'Rau muống', 'rau-muong', 'Rau muống xanh tươi, giòn ngon, trồng theo tiêu chuẩn an toàn.', 10000.00, 100, 'in_stock', 'Bó', 1, '2026-04-07 05:08:40', '2026-04-07 05:11:47'),
(2, 'Cải thìa', 'cai-thia', 'Cải thìa VietGAP, lá xanh mướt, giàu vitamin, thích hợp xào hoặc nấu canh.', 15000.00, 78, 'in_stock', 'Bó', 1, '2026-04-07 05:08:40', '2026-04-07 05:14:44'),
(3, 'Cải ngọt', 'cai-ngot', 'Cải ngọt tươi sạch, cắt tại vườn mỗi sáng sớm, đảm bảo độ tươi ngon.', 14000.00, 60, 'in_stock', 'Bó', 1, '2026-04-07 05:08:40', '2026-04-07 05:10:16'),
(4, 'Bắp cải trắng', 'bap-cai-trang', 'Bắp cải cuộn chặt, lá giòn ngọt, thích hợp làm salad hoặc xào.', 20000.00, 40, 'in_stock', 'Bắp', 1, '2026-04-07 05:08:40', '2026-04-07 05:09:29'),
(5, 'Cà chua', 'ca-chua', 'Cà chua chín mọng đỏ tươi, cung cấp nhiều vitamin C và Lycopene.', 25000.00, 120, 'in_stock', 'kg', 1, '2026-04-07 05:08:40', '2026-04-07 05:09:36'),
(6, 'Cà rốt', 'ca-rot', 'Cà rốt Đà Lạt, củ to đều, màu cam tươi tắn, giàu vitamin A.', 22000.00, 90, 'in_stock', 'kg', 1, '2026-04-07 05:08:40', '2026-04-07 05:10:09'),
(7, 'Khoai tây', 'khoai-tay', 'Khoai tây củ to, bở, ruột vàng, không mọc mầm, an toàn cho sức khỏe.', 30000.00, 100, 'in_stock', 'kg', 1, '2026-04-07 05:08:40', '2026-04-07 05:11:11'),
(8, 'Bí đỏ', 'bi-do', 'Bí đỏ hồ lô dẻo ngọt, thích hợp nấu canh xương hoặc làm sữa bí đỏ.', 18000.00, 35, 'in_stock', 'kg', 1, '2026-04-07 05:08:40', '2026-04-07 05:09:04'),
(9, 'Hành tây', 'hanh-tay', 'Hành tây củ lớn, giòn ngọt, không bị hăng gắt, làm tăng hương vị món ăn.', 20000.00, 50, 'in_stock', 'kg', 1, '2026-04-07 05:08:40', '2026-04-07 05:10:53'),
(10, 'Tỏi khô', 'toi-kho', 'Tỏi củ chắc, tép đều, mùi thơm đặc trưng, gia vị không thể thiếu trong bếp.', 45000.00, 40, 'in_stock', 'kg', 1, '2026-04-07 05:08:40', '2026-04-07 05:11:58'),
(11, 'Ớt sừng', 'ot-sung', 'Ớt sừng đỏ tươi, cay vừa, thích hợp làm gia vị hoặc trang trí món ăn.', 50000.00, 20, 'in_stock', 'kg', 1, '2026-04-07 05:08:40', '2026-04-07 05:12:24'),
(12, 'Rau dền', 'rau-den', 'Rau dền đỏ tươi, bổ máu, thanh mát, tuyệt vời cho các món canh mùa hè.', 12000.00, 70, 'in_stock', 'Bó', 1, '2026-04-07 05:08:40', '2026-04-07 05:11:38'),
(13, 'Mồng tơi', 'mong-toi', 'Mồng tơi lá non, xanh mướt, nấu canh cua hoặc canh ngao rất ngọt nước.', 12000.00, 65, 'in_stock', 'Bó', 1, '2026-04-07 05:08:40', '2026-04-07 05:11:21'),
(14, 'Dưa leo', 'dua-leo', 'Dưa leo giống Nhật giòn ngọt, đặc ruột, không bị đắng.', 18000.00, 110, 'in_stock', 'kg', 1, '2026-04-07 05:08:40', '2026-04-07 05:10:36'),
(15, 'Xà lách', 'xa-lach', 'Xà lách mỡ cuộn non, không dập nát, lý tưởng cho món salad trộn.', 25000.00, 45, 'in_stock', 'kg', 1, '2026-04-07 05:08:40', '2026-04-07 05:12:08'),
(16, 'Bông cải xanh', 'bong-cai-xanh', 'Bông cải xanh (Broccoli) tươi ngon, nụ hoa khít đều, siêu thực phẩm chống oxy hóa.', 40000.00, 30, 'in_stock', 'Bắp', 1, '2026-04-07 05:08:40', '2026-04-07 05:09:17'),
(17, 'Đậu cô ve', 'dau-co-ve', 'Đậu cô ve hạt nhỏ, trái thẳng, xào tỏi ăn giòn sần sật.', 28000.00, 45, 'in_stock', 'kg', 1, '2026-04-07 05:08:40', '2026-04-07 05:12:16'),
(18, 'Khoai lang mật', 'khoai-lang-mat', 'Khoai lang mật Đà Lạt, chảy mật ngọt lịm khi nướng hoặc luộc.', 35000.00, 80, 'in_stock', 'kg', 1, '2026-04-07 05:08:40', '2026-04-07 05:11:03'),
(19, 'Củ cải trắng', 'cu-cai-trang', 'Củ cải trắng to, mọng nước, dùng để hầm xương lấy nước ngọt tự nhiên.', 16000.00, 60, 'in_stock', 'kg', 1, '2026-04-07 05:08:40', '2026-04-07 05:10:29'),
(20, 'Hành lá', 'hanh-la', 'Hành lá cắt rễ tươm tất, lá xanh không bị úa vàng, gia vị thiết yếu hàng ngày.', 30000.00, 30, 'in_stock', 'kg', 1, '2026-04-07 05:08:40', '2026-04-07 05:10:43'),
(21, 'Táo Fuji', 'tao-fuji', 'Táo Fuji nhập khẩu giòn ngọt, mọng nước, cung cấp nhiều chất xơ và vitamin C.', 60000.00, 50, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:35:08'),
(22, 'Cam sành', 'cam-sanh', 'Cam sành mọng nước, vỏ mỏng, vắt nước uống giải nhiệt cực kỳ hiệu quả.', 25000.00, 100, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:31:08'),
(23, 'Nho mẫu đơn', 'nho-mau-don', 'Nho xanh mẫu đơn giòn, ngọt lịm, không hạt, dòng trái cây cao cấp.', 150000.00, 30, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:34:10'),
(24, 'Chuối tiêu hồng', 'chuoi-tieu-hong', 'Chuối chín tự nhiên, thơm lừng, dẻo ngọt, cung cấp năng lượng tức thì.', 20000.00, 80, 'in_stock', 'Nải', 2, '2026-04-07 05:29:52', '2026-04-07 05:32:44'),
(25, 'Xoài cát Hòa Lộc', 'xoai-cat-hoa-loc', 'Xoài cát Hòa Lộc chín cây, thịt chắc, vị ngọt thanh, hương thơm đặc trưng.', 65000.00, 40, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:35:17'),
(26, 'Dưa hấu', 'dua-hau', 'Dưa hấu đỏ tươi, vỏ mỏng, ít hạt, nhiều nước giải khát mùa hè.', 15000.00, 60, 'in_stock', 'Trái', 2, '2026-04-07 05:29:52', '2026-04-07 05:33:16'),
(27, 'Bưởi da xanh', 'buoi-da-xanh', 'Bưởi da xanh ruột hồng, tép bưởi mọng nước, vị ngọt rôn rốt không bị the.', 45000.00, 50, 'in_stock', 'Trái', 2, '2026-04-07 05:29:52', '2026-04-07 05:31:45'),
(28, 'Thanh long ruột đỏ', 'thanh-long-ruot-do', 'Thanh long ruột đỏ ngọt đậm, giàu chất chống oxy hóa và vitamin.', 35000.00, 45, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:34:58'),
(29, 'Sầu riêng Ri6', 'sau-rieng-ri6', 'Sầu riêng cơm vàng hạt lép, thịt dẻo béo ngậy, mùi thơm nức mũi.', 120000.00, 20, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:34:48'),
(30, 'Bơ sáp', 'bo-sap', 'Bơ sáp dẻo béo, hạt nhỏ, thích hợp làm sinh tố hoặc ăn kèm salad.', 40000.00, 60, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:31:38'),
(31, 'Măng cụt', 'mang-cut', 'Nữ hoàng trái cây, vỏ mỏng, ruột trắng muốt, vị chua ngọt thanh tao.', 65000.00, 35, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:34:27'),
(32, 'Nhãn lồng', 'nhan-long', 'Nhãn lồng Hưng Yên cùi dày, hạt nhỏ, nước mọng ngọt lịm.', 35000.00, 70, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:34:01'),
(33, 'Chôm chôm nhãn', 'chom-chom-nhan', 'Chôm chôm tróc hạt, thịt giòn dai, vị ngọt thanh không bị chua.', 30000.00, 80, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:32:50'),
(34, 'Lê Hàn Quốc', 'le-han-quoc', 'Lê trái to, giòn rụm, siêu nhiều nước, để tủ lạnh ăn cực mát.', 80000.00, 40, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:33:49'),
(35, 'Dưa lưới', 'dua-luoi', 'Dưa lưới ruột cam, ngọt lịm, giòn thơm, trồng theo chuẩn nhà màng.', 45000.00, 50, 'in_stock', 'Trái', 2, '2026-04-07 05:29:52', '2026-04-07 05:33:24'),
(36, 'Đu đủ ruột đỏ', 'du-du-ruot-do', 'Đu đủ chín cây tự nhiên, thịt dày dẻo, ngọt thanh, cực tốt cho tiêu hóa.', 18000.00, 60, 'in_stock', 'Trái', 2, '2026-04-07 05:29:52', '2026-04-07 05:35:25'),
(37, 'Ổi lê Đài Loan', 'oi-le-dai-loan', 'Ổi giòn, ít hạt, vị ngọt nhẹ, dồi dào vitamin C giúp đẹp da.', 20000.00, 100, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:34:39'),
(38, 'Kiwi xanh', 'kiwi-xanh', 'Kiwi xanh New Zealand chua chua ngọt ngọt, dồi dào dinh dưỡng.', 110000.00, 30, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:33:36'),
(39, 'Mận hậu', 'man-hau', 'Mận hậu quả to, da căng bóng, vị chua ngọt hài hòa chấm muối tôm.', 45000.00, 50, 'in_stock', 'kg', 2, '2026-04-07 05:29:52', '2026-04-07 05:34:18'),
(40, 'Dâu tây Đà Lạt', 'dau-tay-da-lat', 'Dâu tây đỏ mọng, chua ngọt dôn dốt, thơm lừng, thu hoạch trong ngày.', 120000.00, 25, 'in_stock', 'Hộp', 2, '2026-04-07 05:29:52', '2026-04-07 05:33:07');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_images`
--

CREATE TABLE `product_images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `product_images`
--

INSERT INTO `product_images` (`id`, `product_id`, `image`, `created_at`, `updated_at`) VALUES
(1, 2, 'products/EcHhJD7XtV7IkzNQZTAgpzHtyAJ50552Jf0NQXaj.jpg', '2026-04-07 05:13:25', '2026-04-07 05:13:25'),
(2, 1, 'products/rau-muong.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(3, 3, 'products/cai-ngot.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(4, 4, 'products/bap-cai-trang.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(5, 5, 'products/ca-chua.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(6, 6, 'products/ca-rot.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(7, 7, 'products/khoai-tay.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(8, 8, 'products/bi-do.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(9, 9, 'products/hanh-tay.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(10, 10, 'products/toi-kho.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(11, 11, 'products/ot-sung.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(12, 12, 'products/rau-den.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(13, 13, 'products/mong-toi.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(14, 14, 'products/dua-leo.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(15, 15, 'products/xa-lach.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(16, 16, 'products/bong-cai-xanh.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(17, 17, 'products/dau-co-ve.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(18, 18, 'products/khoai-lang-mat.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(19, 19, 'products/cu-cai-trang.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(20, 20, 'products/hanh-la.jpg', '2026-04-07 05:26:03', '2026-04-07 05:26:03'),
(21, 21, 'products/tao-fuji.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(22, 22, 'products/cam-sanh.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(23, 23, 'products/nho-mau-don.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(24, 24, 'products/chuoi-tieu-hong.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(25, 25, 'products/xoai-cat-hoa-loc.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(26, 26, 'products/dua-hau.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(27, 27, 'products/buoi-da-xanh.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(28, 28, 'products/thanh-long-ruot-do.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(29, 29, 'products/sau-rieng-ri6.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(30, 30, 'products/bo-sap.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(31, 31, 'products/mang-cut.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(32, 32, 'products/nhan-long.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(33, 33, 'products/chom-chom-nhan.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(34, 34, 'products/le-han-quoc.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(35, 35, 'products/dua-luoi.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(36, 36, 'products/du-du-ruot-do.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(37, 37, 'products/oi-le-dai-loan.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(38, 38, 'products/kiwi-xanh.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(39, 39, 'products/man-hau.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24'),
(40, 40, 'products/dau-tay-da-lat.jpg', '2026-04-07 05:41:24', '2026-04-07 05:41:24');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reviews`
--

CREATE TABLE `reviews` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `rating` tinyint(3) UNSIGNED NOT NULL,
  `comment` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `roles`
--

INSERT INTO `roles` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'admin', '2026-01-28 03:33:26', '2026-01-28 03:33:26'),
(2, 'staff', '2026-01-28 03:33:26', '2026-01-28 03:33:26'),
(3, 'customer', '2026-01-28 03:33:26', '2026-01-28 03:33:26');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `roles_permissions`
--

CREATE TABLE `roles_permissions` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `roles_permissions`
--

INSERT INTO `roles_permissions` (`role_id`, `permission_id`, `created_at`, `updated_at`) VALUES
(1, 1, NULL, NULL),
(1, 2, NULL, NULL),
(1, 3, NULL, NULL),
(1, 4, NULL, NULL),
(1, 5, NULL, NULL),
(2, 2, NULL, NULL),
(2, 5, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('04x257QGrdcC2NSNru8HaQ84aOvMq35HQlw3kUrP', 8, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiOHNHYUdFeTA1WFVCb2FIY2l2THk2bmVwU0dCaWp6TkVBb0lGa0x4NCI7czoxODoiZmxhc2hlcjo6ZW52ZWxvcGVzIjthOjA6e31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozMDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL29yZGVyLzUwIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6ODt9', 1775801206),
('egdxhBhjaASxAAzD1NJQ16ryCjXyTaCPZkX5y6Kb', 8, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTo2OntzOjY6Il90b2tlbiI7czo0MDoiNWJFMUFuMWJwOXdnNHh3OEFPNnVnUlk1bFVZUVU5RmlwREZsOVAzaiI7czoxODoiZmxhc2hlcjo6ZW52ZWxvcGVzIjthOjA6e31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2FkbWluL2NhdGVnb3JpZXMiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUyOiJsb2dpbl9hZG1pbl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjI7czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6ODt9', 1775794166),
('TnyBKBMKoYreXS1cEWlqrbNp7zQMyYAbviXg9pgA', 8, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTo2OntzOjY6Il90b2tlbiI7czo0MDoiSWlaUmlkRnUwa0JVVllzalF6SFVwUzlzcmpjNU9EbGxZUjhtNnRzOSI7czoxODoiZmxhc2hlcjo6ZW52ZWxvcGVzIjthOjA6e31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czoyMToiaHR0cDovLzEyNy4wLjAuMTo4MDAwIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MjoibG9naW5fYWRtaW5fNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToyO3M6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjg7fQ==', 1775878845),
('TzGYf9ATSc1JBCh0WpIgzJsXyBosQ3Ev6IDFGdWI', 8, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiNGtvcHhuSkNJUFVZRmlBemR6MHE4SWdIaW52NkFYS1NxUWlJY2tYaSI7czoxODoiZmxhc2hlcjo6ZW52ZWxvcGVzIjthOjA6e31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozMDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3Byb2R1Y3RzIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6ODt9', 1775898603),
('VZzJj8dnXdsdSjfE5KGDgCAplLAHCytBnR1AAkCX', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiMjB4TVlXT3JDeWJNQjJVNDNXQ21KbHVIeGZxSWpBc1F2emxsalNOcCI7czoxODoiZmxhc2hlcjo6ZW52ZWxvcGVzIjthOjA6e31zOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czoyMToiaHR0cDovLzEyNy4wLjAuMTo4MDAwIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1775878829);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `shipping_addresses`
--

CREATE TABLE `shipping_addresses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `shipping_addresses`
--

INSERT INTO `shipping_addresses` (`id`, `user_id`, `full_name`, `phone`, `address`, `city`, `default`, `created_at`, `updated_at`) VALUES
(1, 8, 'TRẦN DUY TRƯỜNG', '0335064110', '614/59 đường 79, Phước Long B', 'Hồ Chí Minh', 1, '2026-04-07 04:43:58', '2026-04-07 04:43:58');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `status` enum('pending','active','banned','deleted') NOT NULL DEFAULT 'pending',
  `phone_number` varchar(255) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `activation_token` varchar(255) DEFAULT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `status`, `phone_number`, `avatar`, `address`, `role_id`, `activation_token`, `google_id`, `created_at`, `updated_at`) VALUES
(2, 'Admin User', 'admin@gmail.com', '$2y$12$Wbd88SpMS8h2EZmoCSeb5Om1oPDImpx7g3WFJwix8tXDokZ25F1re', 'active', '0999999999', '', 'Hanoi, Vietnam', 1, NULL, NULL, '2026-01-28 03:33:27', '2026-01-28 03:33:27'),
(3, 'Staff User', 'staff@gmail.com', '$2y$12$v.bRngp4zxl/Q5x3YE4hTusorXrGtUvDRR9Muy93XzY/tKxfielV6', 'active', '0888888888', '', 'Hanoi, Vietnam', 2, NULL, NULL, '2026-01-28 03:33:27', '2026-01-28 03:33:27'),
(4, 'Nguyen Van A', 'nguyenvana@gmail.com', '$2y$12$AQY2kwewZs9s5m80dkvFr.PRxNswsLehL92OVwXhuiH37Nkh7db4u', 'active', '0123456789', '', 'Hanoi, Vietnam', 3, NULL, NULL, '2026-01-28 03:33:28', '2026-01-28 03:33:28'),
(5, 'Tran Thi B', 'tranthib@gmail.com', '$2y$12$qQjo0v3oivq2dt7mrDYKJ.S0VuSS6iu.s4SJ3SBHru880T4.bF/3e', 'pending', '0987654321', '', 'Ho Chi Minh City, Vietnam', 3, NULL, NULL, '2026-01-28 03:33:28', '2026-01-28 03:33:28'),
(6, 'Le Van C', 'levanc@gmail.com', '$2y$12$yY8ZPUCaQ68yoWZSV6EC1.wE1FY0TW1vjB.v4IN1on/5k8CUc.nXy', 'pending', '0912345678', '', 'Da Nang, Vietnam', 3, NULL, NULL, '2026-01-28 03:33:29', '2026-01-28 03:33:29'),
(7, 'TRẦN DUY TRƯỜNG', 'dp1.1a8.truong@gmail.com', '$2y$12$Rv7QJJiJ/6u5r7vE/F45.OyNi1Cgn2CsrpK2qHelYgl1HYswyPpmi', 'deleted', NULL, NULL, NULL, 3, 'djDr7iMxt0GABMGprzoPWZj7szXhGf3GQIE2BAXELWaSRQaCLsVe7nD9sN308iCP', NULL, '2026-01-28 03:36:42', '2026-04-07 04:44:37'),
(8, 'TRẦN DUY TRƯỜNG', 'leanh26191@gmail.com', '$2y$12$VgMMFmHzXCE5pL2Gdg8ut.ir92PBMEUupFJtq4uifwxlCARTAp0t6', 'active', '0335064110', NULL, '614/59 đường 79, Phước Long B', 3, NULL, NULL, '2026-01-28 03:48:14', '2026-04-07 04:44:29');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `wishlists`
--

CREATE TABLE `wishlists` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_items_user_id_foreign` (`user_id`),
  ADD KEY `cart_items_product_id_foreign` (`product_id`);

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_name_unique` (`name`),
  ADD UNIQUE KEY `categories_slug_unique` (`slug`);

--
-- Chỉ mục cho bảng `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chat_messages_user_id_foreign` (`user_id`),
  ADD KEY `chat_messages_guest_token_index` (`guest_token`);

--
-- Chỉ mục cho bảng `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_user_id_foreign` (`user_id`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_user_id_foreign` (`user_id`),
  ADD KEY `orders_shipping_address_id_foreign` (`shipping_address_id`);

--
-- Chỉ mục cho bảng `orders_status_history`
--
ALTER TABLE `orders_status_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_status_history_order_id_foreign` (`order_id`);

--
-- Chỉ mục cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_items_order_id_foreign` (`order_id`),
  ADD KEY `order_items_product_id_foreign` (`product_id`);

--
-- Chỉ mục cho bảng `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Chỉ mục cho bảng `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_order_id_foreign` (`order_id`);

--
-- Chỉ mục cho bảng `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_unique` (`name`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `products_slug_unique` (`slug`),
  ADD KEY `products_category_id_foreign` (`category_id`);

--
-- Chỉ mục cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_images_product_id_foreign` (`product_id`);

--
-- Chỉ mục cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reviews_user_id_foreign` (`user_id`),
  ADD KEY `reviews_product_id_foreign` (`product_id`);

--
-- Chỉ mục cho bảng `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_unique` (`name`);

--
-- Chỉ mục cho bảng `roles_permissions`
--
ALTER TABLE `roles_permissions`
  ADD KEY `roles_permissions_role_id_foreign` (`role_id`),
  ADD KEY `roles_permissions_permission_id_foreign` (`permission_id`);

--
-- Chỉ mục cho bảng `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Chỉ mục cho bảng `shipping_addresses`
--
ALTER TABLE `shipping_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shipping_addresses_user_id_foreign` (`user_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_role_id_foreign` (`role_id`);

--
-- Chỉ mục cho bảng `wishlists`
--
ALTER TABLE `wishlists`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wishlists_user_id_foreign` (`user_id`),
  ADD KEY `wishlists_product_id_foreign` (`product_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT cho bảng `chat_messages`
--
ALTER TABLE `chat_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT cho bảng `contacts`
--
ALTER TABLE `contacts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT cho bảng `orders_status_history`
--
ALTER TABLE `orders_status_history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT cho bảng `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT cho bảng `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `shipping_addresses`
--
ALTER TABLE `shipping_addresses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `wishlists`
--
ALTER TABLE `wishlists`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD CONSTRAINT `chat_messages_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_shipping_address_id_foreign` FOREIGN KEY (`shipping_address_id`) REFERENCES `shipping_addresses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `orders_status_history`
--
ALTER TABLE `orders_status_history`
  ADD CONSTRAINT `orders_status_history_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `roles_permissions`
--
ALTER TABLE `roles_permissions`
  ADD CONSTRAINT `roles_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `roles_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `shipping_addresses`
--
ALTER TABLE `shipping_addresses`
  ADD CONSTRAINT `shipping_addresses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `wishlists`
--
ALTER TABLE `wishlists`
  ADD CONSTRAINT `wishlists_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlists_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
