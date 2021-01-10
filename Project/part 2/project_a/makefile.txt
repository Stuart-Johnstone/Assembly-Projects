m4 project1.asm > project1.s
m4 project2.asm > project2.s
as project1.s -o project1.o
as project2.s -o project2.o
gcc project1.o project2.o -o project
gdb ./project