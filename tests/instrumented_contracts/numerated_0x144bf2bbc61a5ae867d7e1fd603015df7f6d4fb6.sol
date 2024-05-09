1 contract CoinFlipLotto      
2 {
3     address owner = msg.sender;
4     uint msgValue;
5     uint msgGas;
6     string greeting;    
7 
8     function Greeter(string _greeting) public  
9     {
10         
11         msgValue = msg.value;
12         msgGas = msg.gas;
13         greeting = _greeting;
14     }
15     
16     modifier onlyBy(address _account)
17     {
18         if (msg.sender != _account)
19             throw;
20         _
21     }
22 
23     function greet()  constant returns (string)          
24     {
25         return greeting;
26     }
27     
28     function getBlockNumber()  constant returns (uint)  // this doesn't have anything to do with the act of greeting
29     {													// just demonstrating return of some global variable
30         return block.number;
31     }
32     
33     function setGreeting(string _newgreeting) 
34     {
35         greeting = _newgreeting;
36     }
37     
38     function terminate()
39     { 
40         if (msg.sender == owner)
41             suicide(owner); 
42     }
43     
44     function terminateAlt() onlyBy(owner)
45     { 
46             suicide(owner); 
47     }
48     
49 
50 }