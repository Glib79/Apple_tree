CREATE TABLE apple_tree (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  left_edge INT UNSIGNED NOT NULL,
  right_edge INT UNSIGNED NOT NULL,
  name VARCHAR(20),
  INDEX (left_edge),
  INDEX (right_edge)
);
