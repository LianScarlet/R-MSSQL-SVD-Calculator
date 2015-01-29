create table $(ExprName)_DD
(
	DID1 int,
	DID2 int,
	Similarity int,
	Part tinyint
)

create table $(ExprName)_TT
(
	TID1 int,
	TID2 int,
	Similarity int,
	Part tinyint
)

create table $(ExprName)_TD
(
	TID int,
	DID int,
	Similarity int,
	Part tinyint
)