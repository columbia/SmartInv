1 contract squareRootPonzi {
2     
3     struct MasterCalculators {
4         
5         address ethereumAddress;
6         string name;
7         uint squareRoot;
8         
9     }
10     MasterCalculators[] public masterCalculator;
11     
12     uint public calculatedTo = 0;
13     
14     
15     function() {
16         
17         if (msg.value == 1 finney) {
18             
19             if (this.balance > 2 finney) {
20             
21                 uint index = masterCalculator.length + 1;
22                 masterCalculator[index].ethereumAddress = msg.sender;
23                 masterCalculator[index].name = "masterly calculated: ";
24                 calculatedTo += 100 ether; // which is a shorter way to the number 100,000,000,000,000,000,000 or 1e+20
25                 masterCalculator[index].squareRoot = CalculateSqrt(calculatedTo);
26                 
27                 if (masterCalculator.length > 3) {
28                 
29                     uint to = masterCalculator.length - 3;
30                     masterCalculator[to].ethereumAddress.send(2 finney);
31                     
32                 }
33                 
34             }
35             
36         }
37         
38     }
39     
40     
41     function CalculateSqrt(uint x) internal returns (uint y) {
42         
43         uint z = (x + 1) / 2;
44         y = x;
45         while (z < y) {
46             y = z;
47             z = (x / z + z) / 2;
48         }
49         
50     }
51     
52     
53     function sqrt(uint x) returns (uint) {
54         
55         if (x > masterCalculator.length + 1) return 0;
56         else return masterCalculator[x].squareRoot;
57         
58     }
59     
60     
61 }