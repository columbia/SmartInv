1 pragma solidity ^0.4.18;
2 
3 contract Exponent {
4     function checkMultOverflow(uint x, uint y) public pure returns(bool) {
5         if(y == 0) return false;
6         return (((x*y) / y) != x);
7     }
8     
9     function exp(uint p, uint q, uint precision) public pure returns(uint){
10         uint n = 0;
11         uint nFact = 1;
12         uint currentP = 1;
13         uint currentQ = 1;
14         
15         uint sum = 0;
16         
17         while(true) {
18             if(checkMultOverflow(currentP, precision)) return sum; 
19             if(checkMultOverflow(currentQ, nFact)) return sum;            
20             
21             sum += (currentP * precision ) / (currentQ * nFact);
22             
23             n++;
24             
25             if(checkMultOverflow(currentP,p)) return sum;            
26             if(checkMultOverflow(currentQ,q)) return sum;
27             if(checkMultOverflow(nFact,n)) return sum;
28             
29             currentP *= p;
30             currentQ *= q;
31             nFact *= n;
32         }
33 
34     }
35     
36     event ExpResult(uint result, uint precision);
37     
38     function expTx(uint p, uint q, uint precision) public {
39         ExpResult(exp(p,q,precision),precision);
40     }
41     
42 }