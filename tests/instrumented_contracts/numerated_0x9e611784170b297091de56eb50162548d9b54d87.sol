1 pragma solidity ^0.4.8;
2 
3 contract Crowdsale {
4 	function invest(address receiver) payable{}
5 }
6 /**
7 *	This contract accepts investments, which can be sent to the specified ICO contract buy calling buyTokens().
8 *	Funds can be withdrawn anytime as long as the tokens have not yet been purchased.
9 *	Author: Julia Altenried
10 **/
11 contract Investment{
12 	Crowdsale public ico;
13 	address[] public investors;
14 	mapping(address => uint) public balanceOf;
15 
16 
17 	/** constructs an investment contract for an ICO contract **/
18 	function Investment(){
19 		ico = Crowdsale(0x7be89db09b0c1023fd0407b24b98810ae97f61c1);
20 	}
21 
22 	/** make an investment **/
23 	function() payable{
24 		if(!isInvestor(msg.sender)){
25 			investors.push(msg.sender);
26 		}
27 		balanceOf[msg.sender] += msg.value;
28 	}
29 
30 	/** checks if the address invested **/
31 	function isInvestor(address who) returns (bool){
32 		for(uint i = 0; i< investors.length; i++)
33 			if(investors[i] == who)
34 				return true;
35 		return false;
36 	}
37 
38 	/** buys token in behalf of the investors **/
39 	function buyTokens(uint from, uint to){
40 		uint amount;
41 		if(to>investors.length)
42 			to = investors.length;
43 		for(uint i = from; i < to; i++){
44 			if(balanceOf[investors[i]]>0){
45 				amount = balanceOf[investors[i]];
46 				delete balanceOf[investors[i]];
47 				ico.invest.value(amount)(investors[i]);
48 			}
49 		}
50 	}
51 
52 	/** In case an investor wants to retrieve his or her funds (only possible before tokens are bought). **/
53 	function withdraw(){
54 		msg.sender.send(balanceOf[msg.sender]);
55 	}
56 
57 	/** returns the number of investors**/
58 	function getNumInvestors() constant returns(uint){
59 		return investors.length;
60 	}
61 
62 }