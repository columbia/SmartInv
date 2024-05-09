1 /**
2 *	This investment contract accepts investments, which will be sent to the Edgeless ICO contract as soon as it starts buy calling buyTokens().
3 *   This way investors do not have to buy tokens in time theirselves and still do profit from the power hour offer.
4 *	Investors may withdraw their funds anytime if they change their mind as long as the tokens have not yet been purchased.
5 *	Author: Julia Altenried
6 **/
7 
8 pragma solidity ^0.4.8;
9 
10 contract Crowdsale {
11 	function invest(address receiver) payable{}
12 }
13 
14 contract SafeMath {
15   //internals
16   function safeAdd(uint a, uint b) internal returns (uint) {
17     uint c = a + b;
18     assert(c>=a && c>=b);
19     return c;
20   }
21   function assert(bool assertion) internal {
22     if (!assertion) throw;
23   }
24 }
25 
26 contract Investment is SafeMath{
27 	Crowdsale public ico;
28 	address[] public investors;
29 	mapping(address => uint) public balanceOf;
30 	mapping(address => bool) invested;
31 
32 
33 	/** constructs an investment contract for an ICO contract **/
34 	function Investment(){
35 		ico = Crowdsale(0x362bb67f7fdbdd0dbba4bce16da6a284cf484ed6);
36 	}
37 
38 	/** make an investment **/
39 	function() payable{
40 		if(msg.value > 0){
41 			//only checking balance of msg.sender would not suffice, since an attacker could fill up the array by
42 			//repeated investment and withdrawal, which would require a huge number of buyToken()-calls when the ICO ends
43 			if(!invested[msg.sender]){
44 				investors.push(msg.sender);
45 				invested[msg.sender] = true;
46 			}
47 			balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], msg.value);
48 		}
49 	}
50 
51 
52 
53 	/** buys tokens in behalf of the investors by calling the ico contract
54 	*   starting with the investor at index from and ending with investor at index to.
55 	*   This function will be called as soon as the ICO starts and as often as necessary, until all investments were made. **/
56 	function buyTokens(uint from, uint to){
57 		uint amount;
58 		if(to>investors.length)
59 			to = investors.length;
60 		for(uint i = from; i < to; i++){
61 			if(balanceOf[investors[i]]>0){
62 				amount = balanceOf[investors[i]];
63 				delete balanceOf[investors[i]];
64 				ico.invest.value(amount)(investors[i]);
65 			}
66 		}
67 	}
68 
69 	/** In case an investor wants to retrieve his or her funds he or she can call this function.
70 	*   (only possible before tokens are bought) **/
71 	function withdraw(){
72 		uint amount = balanceOf[msg.sender];
73 		balanceOf[msg.sender] = 0;
74 		if(!msg.sender.send(amount))
75 			balanceOf[msg.sender] = amount;
76 	}
77 
78 	/** returns the number of investors **/
79 	function getNumInvestors() constant returns(uint){
80 		return investors.length;
81 	}
82 
83 }