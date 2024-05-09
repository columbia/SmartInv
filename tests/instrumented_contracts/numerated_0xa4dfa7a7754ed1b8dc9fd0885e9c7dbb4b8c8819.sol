1 pragma solidity ^0.4.24;
2 contract SafeMath {
3     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
4 	require(a>=0);
5 	require(b>=0);		
6         c = a + b;
7 	require(c >= a);
8 
9     }
10     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
11 	require(a>=0);
12 	require(b>=0);	
13         require(b <= a);
14         c = a - b;
15     }
16    
17 }
18 
19 
20 contract Dinarcoin is SafeMath {
21     mapping (address => uint256) public balanceOf;
22 
23     string public name;
24     string public symbol;
25     uint8 public decimals=18;
26     uint256 public totalSupply;
27     
28     event Transfer( address indexed from, address indexed to, uint256 value);
29 
30     constructor(
31         uint256 initialSupply,
32         string tokenName,
33         string tokenSymbol,
34 	uint8 decimal) public {
35         totalSupply = initialSupply * 10 ** uint256(decimal);  // Update total supply with the decimal amount
36         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
37         name = tokenName;                                   // Set the name for display purposes
38         symbol = tokenSymbol;      
39     }
40 
41     /* Send coins */
42     function _transfer(address _from, address _to, uint256 _value) internal {
43 	require(_to!=0x0);
44 	require(_value>0);
45         require(balanceOf[msg.sender] >= _value); 
46         require(balanceOf[_to] + _value >= balanceOf[_to]); 
47         uint256 previousBalances=balanceOf[_from] + balanceOf[_to];
48         balanceOf[msg.sender] =safeSub(balanceOf[msg.sender], _value); 
49         balanceOf[_to] =safeAdd(balanceOf[_to], _value); 
50 	emit Transfer(_from, _to, _value);
51 	assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52         
53     }
54 	function transfer(address _to, uint256 _value) public returns (bool success){
55 
56 	_transfer(msg.sender, _to, _value);
57 	return true;
58 	}
59 
60 }