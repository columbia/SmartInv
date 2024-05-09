1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {  owner = msg.sender;  }
7     modifier onlyOwner {  require (msg.sender == owner);    _;   }
8     function transferOwnership(address newOwner) onlyOwner public{  owner = newOwner;  }
9 }
10 
11 contract RLLToken is owned {
12     string public name; 
13     string public symbol; 
14     uint8 public decimals = 18;
15     uint256 public totalSupply; 
16 
17     mapping (address => uint256) public balanceOf;
18     mapping (address => uint256) public lockOf;
19 	mapping (address => bool) public frozenAccount; 
20 	
21     event Transfer(address indexed from, address indexed to, uint256 value); 
22     event Burn(address indexed from, uint256 value); 
23     
24     function RLLToken(uint256 initialSupply, string tokenName, string tokenSymbol, address centralMinter) public {
25         if(centralMinter != 0 ) 
26 			owner = centralMinter; 
27 		else
28 			owner = msg.sender;
29 		
30         totalSupply = initialSupply * 10 ** uint256(decimals); 
31         balanceOf[owner] = totalSupply; 
32 
33         name = tokenName;
34         symbol = tokenSymbol;
35     }
36 
37     function _transfer(address _from, address _to, uint256 _value) internal {
38         require (_to != 0x0); 
39         require (balanceOf[_from] > _value); 
40         require (balanceOf[_to] + _value > balanceOf[_to]);
41 		require( balanceOf[_from] - _value >= lockOf[_from] );
42         require(!frozenAccount[_from]); 
43         require(!frozenAccount[_to]);
44 
45 		uint256 previousBalances = balanceOf[_from] +balanceOf[_to]; 
46         
47         balanceOf[_from] -= _value; 
48         balanceOf[_to] +=  _value; 
49 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances); 
50 		emit Transfer(_from, _to, _value); 
51     }
52 	
53     function transfer(address _to, uint256 _value) public {   _transfer(msg.sender, _to, _value);   }
54 
55     function lockAccount(address _spender, uint256 _value) public onlyOwner returns (bool success) {
56         lockOf[_spender] = _value*10 ** uint256(decimals);
57         return true;
58     }
59 
60     function freezeAccount(address target, bool freeze) public onlyOwner {
61         frozenAccount[target] = freeze;
62     }
63 
64     function burn(uint256 _value) public onlyOwner returns (bool success) {
65         require(balanceOf[msg.sender] >= _value);   
66 
67 		balanceOf[msg.sender] -= _value; 
68         totalSupply -= _value; 
69         emit Burn(msg.sender, _value);
70         return true;
71     }
72 	
73 }