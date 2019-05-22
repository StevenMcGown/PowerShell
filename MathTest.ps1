$Source = @"
	public class MathTest {
		public static int Add(int a, int b) {
			return (a+b);
		}
		public static int Multiply(int a, int b) {
			return (a*b);
		}
	}
"@

Add-Type -TypeDefinition $Source
