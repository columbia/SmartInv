1 contract MyScheme {
2  
3     uint treeBalance;
4     uint numInvestorsMinusOne;
5     uint treeDepth;
6     address[] myTree;
7  
8     function MyScheme() {
9         treeBalance = 0;
10         myTree.length = 6;
11         myTree[0] = msg.sender;
12         numInvestorsMinusOne = 0;
13     }
14    
15         function getNumInvestors() constant returns (uint a){
16                 a = numInvestorsMinusOne+1;
17         }
18    
19         function() {
20         uint amount = msg.value;
21         if (amount>=1000000000000000000){
22             numInvestorsMinusOne+=1;
23             myTree[numInvestorsMinusOne]=msg.sender;
24             amount-=1000000000000000000;
25             treeBalance+=1000000000000000000;
26             if (numInvestorsMinusOne<=2){
27                 myTree[0].send(treeBalance);
28                 treeBalance=0;
29                 treeDepth=1;
30             }
31             else if (numInvestorsMinusOne+1==myTree.length){
32                     for(uint i=myTree.length-3*(treeDepth+1);i<myTree.length-treeDepth-2;i++){
33                         myTree[i].send(500000000000000000);
34                         treeBalance-=500000000000000000;
35                     }
36                     uint eachLevelGets = treeBalance/(treeDepth+1)-1;
37                     uint numInLevel = 1;
38                     for(i=0;i<myTree.length-treeDepth-2;i++){
39                         myTree[i].send(eachLevelGets/numInLevel-1);
40                         treeBalance -= eachLevelGets/numInLevel-1;
41                         if (numInLevel*(numInLevel+1)/2 -1== i){
42                             numInLevel+=1;
43                         }
44                     }
45                     myTree.length+=treeDepth+3;
46                     treeDepth+=1;
47             }
48         }
49                 treeBalance+=amount;
50     }
51 }