1 pragma solidity ^0.4.16;
2 
3 contract Utils {
4     function Utils() public {    }
5     modifier greaterThanZero(uint256 _amount) { require(_amount > 0);    _;   }
6     modifier validAddress(address _address) { require(_address != 0x0);  _;   }
7     modifier notThis(address _address) { require(_address != address(this));  _; }
8     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) { uint256 z = _x + _y;  assert(z >= _x);  return z;  }
9     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) { assert(_x >= _y);  return _x - _y;   }
10     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) { uint256 z = _x * _y; assert(_x == 0 || z / _x == _y); return z; }
11 }
12 
13 contract owned {
14     address public owner;
15 
16     function owned() public {  owner = msg.sender;  }
17     modifier onlyOwner {  require (msg.sender == owner);    _;   }
18     function transferOwnership(address newOwner) onlyOwner public{  owner = newOwner;  }
19 }
20 
21 contract Token20 is owned, Utils {
22     string public name; 
23     string public symbol; 
24     uint8 public decimals = 18;
25     uint256 public totalSupply; 
26 
27     mapping (address => uint256) public balanceOf;
28     
29     function Token20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
30 
31         totalSupply = initialSupply * 10 ** uint256(decimals);  
32         balanceOf[msg.sender] = totalSupply; 
33 
34         name = tokenName;
35         symbol = tokenSymbol;
36     }
37 
38     function _transfer(address _from, address _to, uint256 _value) internal {
39 
40       require(_to != 0x0); 
41       require(balanceOf[_from] >= _value); 
42       require(balanceOf[_to] + _value > balanceOf[_to]); 
43       
44       uint256 previousBalances = safeAdd(balanceOf[_from], balanceOf[_to]); 
45       balanceOf[_from] = safeSub(balanceOf[_from], _value); 
46       balanceOf[_to] = safeAdd(balanceOf[_to], _value); 
47       assert(balanceOf[_from] + balanceOf[_to] == previousBalances); 
48     }
49 
50     function transfer(address _to, uint256 _value) public {   _transfer(msg.sender, _to, _value);   }
51 }
52 
53 contract CMCLToken is Token20 {
54     
55     function CMCLToken(uint256 initialSupply, string tokenName, string tokenSymbol, address centralMinter) public Token20 (initialSupply, tokenName, tokenSymbol) {
56         if(centralMinter != 0 ) 
57 			owner = centralMinter; 
58     }
59 }