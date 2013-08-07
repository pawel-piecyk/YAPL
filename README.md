YAPL
====

Yet Another Programming Language. My university project of simple interpreted programming language. Syntax is a bit weird but it wasn't the main purpose of class ;-)

Sample code:

	dspl "Euclidean algorithm (greatest common divisor of 1071 and 1029) %n";

	def GCD: A, B
	@b
		loop B<>0:
		@b
			set C <- A % B;
			set A <- B;
			set B <- C;
		@e
		
		dspl A;
	@e

	dspl "Value of GCD(1071, 1029) is: ";
	exec GCD <- 1071,1029;