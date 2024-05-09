1 pragma solidity ^0.4.16;
2 contract owned {
3     address public owner;
4     constructor() public {
5         owner = msg.sender;
6     }
7     modifier onlyOwner {
8         require(msg.sender == owner);
9         _;
10     }
11     function transferOwnership(address newOwner) onlyOwner public {
12         owner = newOwner;
13     }
14 }
15 contract ExpressCoin is owned {
16     string public constant name = "ExpressCoin";
17     string public constant symbol = "XPC";
18     uint public constant decimals = 8;
19     uint constant ONETOKEN = 10 ** uint(decimals);
20     uint constant MILLION = 1000000; 
21     uint public totalSupply;
22     constructor() public {
23         totalSupply = 88 * MILLION * ONETOKEN;                        
24         balanceOf[msg.sender] = totalSupply;                            
25     }
26     mapping (address => uint256) public balanceOf;
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Burn(address indexed from, uint256 value);
30     
31     function transfer(address _to, uint256 _value) public {
32         _transferXToken(msg.sender, _to, _value);
33     }
34     function _transferXToken(address _from, address _to, uint _value) internal {
35         require(_to != 0x0);
36         require(balanceOf[_from] >= _value);
37         require(balanceOf[_to] + _value > balanceOf[_to]);
38         uint previousBalances = balanceOf[_from] + balanceOf[_to];
39         balanceOf[_from] -= _value;
40         balanceOf[_to] += _value;
41         emit Transfer(_from, _to, _value);
42         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
43     }
44     function() payable public { }
45 
46     function withdrawEther() onlyOwner public{
47         owner.transfer(this.balance);
48     }
49     function mint(address target, uint256 token) onlyOwner public {
50         balanceOf[target] += token;
51         totalSupply += token;
52         emit Transfer(0, this, token);
53         emit Transfer(this, target, token);
54     }
55     function burn(uint256 _value) public returns (bool success) {
56         require(balanceOf[msg.sender] >= _value);   
57         balanceOf[msg.sender] -= _value;            
58         totalSupply -= _value;
59         emit Burn(msg.sender, _value);
60         return true;
61     }
62 }