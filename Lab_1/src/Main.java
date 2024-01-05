import java.util.Scanner;
import java.util.ArrayList;
import java.lang.String;

public class Main{
    public static void main(String[] args){
        final int basis = -10;
        Scanner input=new Scanner(System.in);
        System.out.print("Input a number: ");
        int number = input.nextInt();
        ArrayList <Integer> answer=new ArrayList <Integer>();
        while (number!=0){
            if (number%basis<0){
                answer.add(0, (number%basis + Math.abs(basis))%Math.abs(basis));
                number = number/basis + 1;
            }
            else{
                answer.add(0, Math.abs(number%basis));
                number = number/basis;
            }
        };
        String answer_1 = answer.toString().replace("[", "").replace("]", "").replace(",", "").replace(" ", "");
        System.out.print("Answer: ");
        System.out.print(answer_1);
    }
}