using System;
namespace test
{
	class program {
	
		public double multiplication () {
			double product = number1 * number2;
			return product;
		}

		public double division () {
			double quotient = number1 / number2;
			return quotient;
		}

		public double addition () {
			double sum = number1 + number2;
			return sum;
		}

		public double subtraction () {
			double difference = number1 - number2;
			return difference;
		}

		static void Main() {
			//Input
			string input;
			string input2;
			int number1;
			int number2;
			string operator1;

			Console.WriteLine("Enter operand 1.");
			input = Console.ReadLine();

			Console.WriteLine("Enter operand 2.");
			input2 = Console.ReadLine();

			//convert string to int
			try () {
				number1 = Int32.parse(input);
				number2 = Int32.parse(input2);
			}

			catch (invalidInput) {
				Console.WriteLine("Your input contains non-integer characters.");
			}

		}
	}
}


