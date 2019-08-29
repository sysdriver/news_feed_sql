# User table scheme
CREATE TABLE `user` (
  `id` int(11) NOT NULL  auto_increment COMMENT 'pk',
  `name` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL COMMENT 'hash, en only',
PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

# Post table scheme
CREATE TABLE `post` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(50) NOT NULL,
  `content` varchar(121) NOT NULL,
  `category` enum('cat1','cat2','cat3') NOT NULL,
PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

# post_like  table scheme
CREATE TABLE `post_like` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

ALTER TABLE `post_like`
  ADD UNIQUE KEY `user_post` (`user_id`,`post_id`);

ALTER TABLE `post_like`
  ADD CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_post_id` FOREIGN KEY (`user_id`) REFERENCES `post` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

# 1) запрос на постановку лайка от юзера к новости
INSERT INTO 
  `post_like` (`user_id`, `post_id`) 
VALUES 
  ('1', '1');

# 2) запрос на отмену лайка;
DELETE FROM 
  `post_like` 
WHERE 
  `post_like`.`user_id` = 1 
  AND `post_like`.`post_id` = 1 
LIMIT 1;

# 3) выборка пользователей, оценивших новость, желательно учесть что их могут быть тысячи и сделать возможность постраничного вывода;
SELECT 
  `user_id`,`name`
FROM 
  `post_like` 
INNER JOIN 
  `user` ON `user`.`id` = `post_like`.`user_id` 
WHERE 
  `post_id` = 1 LIMIT 0,10

# 4) запрос для вывода ленты новостей
SELECT 
  `post`.`title`,`post`.`content`,`user`.`name`,`post_like`.`id`
FROM 
  `post`
LEFT JOIN 
  `post_like` ON `post_like`.`post_id`=`post`.`id`
LEFT JOIN 
  `user` ON `user`.`id` = `post_like`.`user_id`
LIMIT 0,10

#5) запрос на добавление поста в ленту
INSERT INTO 
  `post` (`id`, `title`, `content`, `category`) 
VALUES
  (1, 'Very cool new!', 'You will never believe this!', 'cat1');
