# Apple tree

Apple tree is a simple concept of storing parent-children related data in one SQL table. This solution allows for fast data reading but the writing is slow (which is ok because a lot of people can see the apple tree but apple tree is changing slowly).

The concept assumes that each record has two edges (left and right) and all edges are unique. All records with edges between other record's edges are its children. All records with edges surrounding given record's edges are its parents.

example:
```
--------------------------------
|id|left_edge|right_edge| name |
--------------------------------
| 1|        1|        10| trunk|
| 2|        2|         7|branch|
| 3|        3|         6|  twig|
| 4|        4|         5|  leaf|
| 5|        8|         9|  twig|
-------------------------------
```
In this example record 2 (branch) has two children (3 and 4 -> twig and leaf) and it has only one parent (1 - trunk).

To create apple_tree table run create_apple_tree.sql file.

To load example tree run example_apple_tree.sql file.

## Find children

To find all children you need to know the parent left and right edge.

```
SELECT * 
FROM apple_tree 
WHERE left_edge > {left_edge} AND right_edge < {right_edge} 
ORDER BY left_edge;
```
example:
```
SELECT * 
FROM apple_tree 
WHERE left_edge> 2 AND right_edge < 21 
ORDER BY left_edge;
```

## Find parents

To find allparents you need to know the children left and right edge.

```
SELECT * 
FROM apple_tree 
WHERE left_edge < {left_edge} AND right_edge > {right_edge} 
ORDER BY left_edge;
```
example:
```
SELECT * 
FROM apple_tree 
WHERE left_edge < 8 AND right_edge > 9 
ORDER BY left_edge;
```

## Change tree

The best option to manage tree is create SQL procedures or some functions to do this. 
But managing could be done just by running SQL queries (examples below). The queries should be run in transaction to avoid data corruption.
All examples could be easily converted to the functions.

### Add element

In this example I'm adding the farthest element - leaf.
```
START TRANSACTION;
UPDATE apple_tree SET left_edge = left_edge + 2 WHERE left_edge >= 119;
UPDATE apple_tree SET right_edge = right_edge + 2 WHERE right_edge >= 120;
INSERT INTO apple_tree (left_edge, right_edge, name) VALUES (119, 120, 'leaf');
COMMIT;
```
We can also add a parent element (twig) for receantly created leaf:
```
START TRANSACTION;
UPDATE apple_tree SET left_edge = left_edge + 2 WHERE left_edge > 120;
UPDATE apple_tree SET right_edge = right_edge + 2 WHERE right_edge > 120;
UPDATE apple_tree SET left_edge = left_edge + 1, right_edge = right_edge + 1 
WHERE left_edge >= 119 AND right_edge <= 120;
INSERT INTO apple_tree (left_edge, right_edge, name) VALUES (119, 122, 'twig');
COMMIT;
```

### Delete element

In this example I'm deleting the latest element - leaf.
```
START TRANSACTION;
DELETE FROM apple_tree WHERE left_edge = 121;
UPDATE apple_tree SET left_edge = left_edge - 2 WHERE left_edge > 121;
UPDATE apple_tree SET right_edge = right_edge - 2 WHERE right_edge > 122;
COMMIT;
```
We can also delete parent with children.
```
START TRANSACTION;
DELETE FROM apple_tree WHERE left_edge >= 102 AND right_edge  <= 109;
UPDATE apple_tree SET left_edge = left_edge - 8 WHERE left_edge > 102;
UPDATE apple_tree SET right_edge = right_edge - 8 WHERE right_edge > 109;
COMMIT;
```
