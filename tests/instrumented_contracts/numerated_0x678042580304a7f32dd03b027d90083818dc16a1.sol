1 pragma solidity ^0.4.18;
2 contract EtherealFoundationOwned {
3 	address private Owner;
4     
5 	function IsOwner(address addr) view public returns(bool)
6 	{
7 	    return Owner == addr;
8 	}
9 	
10 	function TransferOwner(address newOwner) public onlyOwner
11 	{
12 	    Owner = newOwner;
13 	}
14 	
15 	function EtherealFoundationOwned() public
16 	{
17 	    Owner = msg.sender;
18 	}
19 	
20 	function Terminate() public onlyOwner
21 	{
22 	    selfdestruct(Owner);
23 	}
24 	
25 	modifier onlyOwner(){
26         require(msg.sender == Owner);
27         _;
28     }
29 }
30 
31 contract EtherealTipJar  is EtherealFoundationOwned{
32     string public constant CONTRACT_NAME = "EtherealTipJar";
33     string public constant CONTRACT_VERSION = "A";
34     string public constant QUOTE = "'The universe never did make sense; I suspect it was built on government contract.' -Robert A. Heinlein";
35     
36     
37     event RecievedTip(address indexed from, uint256 value);
38 	function () payable public {
39 		RecievedTip(msg.sender, msg.value);		
40 	}
41 	
42 	event TransferedEth(address indexed to, uint256 value);
43 	function TransferEth(address to, uint256 value) public onlyOwner{
44 	    require(this.balance >= value);
45 	    
46         if(value > 0)
47 		{
48 			to.transfer(value);
49 			TransferedEth(to, value);
50 		}   
51 	}
52 }