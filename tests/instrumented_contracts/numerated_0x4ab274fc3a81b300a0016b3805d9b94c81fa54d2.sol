1 contract owned {
2     address public owner;
3 
4     function owned() {
5         owner = msg.sender;
6     }
7 
8     modifier onlyOwner {
9         if (msg.sender != owner) throw;
10         _
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner {
14         owner = newOwner;
15     }
16 }
17 
18 
19 
20 contract MeatConversionCalculator is owned {
21     uint public amountOfMeatInUnicorn;
22     uint public reliabilityPercentage;
23 
24     /* generates a number from 0 to 2^n based on the last n blocks */
25     function multiBlockRandomGen(uint seed, uint size) constant returns (uint randomNumber) {
26         uint n = 0;
27         for (uint i = 0; i < size; i++){
28             if (uint(sha3(block.blockhash(block.number-i-1), seed ))%2==0)
29                 n += 2**i;
30         }
31         return n;
32     }
33     
34     function MeatConversionCalculator(
35         uint averageAmountOfMeatInAUnicorn, 
36         uint percentOfThatMeatThatAlwaysDeliver
37     ) {
38         changeMeatParameters(averageAmountOfMeatInAUnicorn, percentOfThatMeatThatAlwaysDeliver);
39     }
40     function changeMeatParameters(
41         uint averageAmountOfMeatInAUnicorn, 
42         uint percentOfThatMeatThatAlwaysDeliver
43     ) onlyOwner {
44         amountOfMeatInUnicorn = averageAmountOfMeatInAUnicorn * 1000;
45         reliabilityPercentage = percentOfThatMeatThatAlwaysDeliver;
46     }
47     
48     function calculateMeat(uint amountOfUnicorns) constant returns (uint amountOfMeat) {
49         uint rnd = multiBlockRandomGen(uint(sha3(block.number, now, amountOfUnicorns)), 10);
50 
51        amountOfMeat = (reliabilityPercentage*amountOfUnicorns*amountOfMeatInUnicorn)/100;
52        amountOfMeat += (1024*(100-reliabilityPercentage)*amountOfUnicorns*amountOfMeatInUnicorn)/(rnd*100);
53 
54     }
55 }