1 pragma solidity ^0.4.20;
2 
3 contract SafeMath {
4     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
5 	require(a>=0);
6 	require(b>=0);		
7         c = a + b;
8 	require(c >= a);
9 
10     }
11     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
12 	require(a>=0);
13 	require(b>=0);	
14         require(b <= a);
15         c = a - b;
16     }
17    
18 }
19 
20 
21 contract Buetcoin is SafeMath {
22     mapping (address => uint256) public balanceOf;
23 
24     string public name;
25     string public symbol;
26     uint8 public decimals=18;
27     uint256 public totalSupply;
28     
29     event Transfer( address indexed from, address indexed to, uint256 value);
30 
31     constructor(
32         uint256 initialSupply,
33         string tokenName,
34         string tokenSymbol,
35 	uint8 decimal) public {
36         totalSupply = initialSupply * 10 ** uint256(decimal);  // Update total supply with the decimal amount
37         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
38         name = tokenName;                                   // Set the name for display purposes
39         symbol = tokenSymbol;      
40     }
41 
42     /* Send coins */
43     function _transfer(address _from, address _to, uint256 _value) internal {
44 	require(_to!=0x0);
45 	require(_value>0);
46         require(balanceOf[msg.sender] >= _value); 
47         require(balanceOf[_to] + _value >= balanceOf[_to]); 
48         uint256 previousBalances=balanceOf[_from] + balanceOf[_to];
49         balanceOf[msg.sender] =safeSub(balanceOf[msg.sender], _value); 
50         balanceOf[_to] =safeAdd(balanceOf[_to], _value); 
51 	emit Transfer(_from, _to, _value);
52 	assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
53         
54     }
55 	function transfer(address _to, uint256 _value) public returns (bool success){
56 
57 	_transfer(msg.sender, _to, _value);
58 	return true;
59 	}
60 
61 }