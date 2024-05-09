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
21 contract MyUserToken is owned, Utils {
22     string public name; 
23     string public symbol; 
24     uint8 public decimals = 18;
25     uint256 public totalSupply; 
26 
27     mapping (address => uint256) public balanceOf;
28 
29     event Transfer(address indexed from, address indexed to, uint256 value); 
30     
31     function MyUserToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
32 
33         totalSupply = initialSupply * 10 ** uint256(decimals);  
34         balanceOf[msg.sender] = totalSupply; 
35 
36         name = tokenName;
37         symbol = tokenSymbol;
38     }
39 
40     function _transfer(address _from, address _to, uint256 _value) internal {
41 
42       require(_to != 0x0); 
43       require(balanceOf[_from] >= _value); 
44       require(balanceOf[_to] + _value > balanceOf[_to]); 
45       
46       uint256 previousBalances = safeAdd(balanceOf[_from], balanceOf[_to]); 
47       balanceOf[_from] = safeSub(balanceOf[_from], _value); 
48       balanceOf[_to] = safeAdd(balanceOf[_to], _value); 
49       emit Transfer(_from, _to, _value);
50       assert(balanceOf[_from] + balanceOf[_to] == previousBalances); 
51     }
52 
53     function transfer(address _to, uint256 _value) public {   _transfer(msg.sender, _to, _value);   }
54 }