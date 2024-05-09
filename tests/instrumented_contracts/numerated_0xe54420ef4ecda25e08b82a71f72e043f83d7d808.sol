1 contract TheRichestMan {
2     address owner;
3 
4     address public theRichest;
5     uint public treasure=0;
6     uint public withdrawDate=0;
7 
8     function TheRichestMan(address _owner)
9     {
10         owner=_owner;
11     }
12 
13     function () public payable{
14         require(treasure < msg.value);
15         treasure = msg.value;
16         withdrawDate = now + 2 days;
17         theRichest = msg.sender;
18     }
19 
20     function withdraw() public{
21         require(now >= withdrawDate);
22         require(msg.sender == theRichest);
23 
24         //Reset game
25         theRichest = 0;
26         treasure = 0;
27 
28         //taking my 1% from the total prize.
29         owner.transfer(this.balance/100);
30         
31         //reward
32         msg.sender.transfer(this.balance);
33     }
34 
35 	// in case of long idling
36 	function kill() public
37 	{
38 		require(msg.sender==owner);
39 	        require(now >= withdrawDate);
40 		owner.transfer(this.balance/100);
41 		suicide(theRichest);
42 	}
43 }