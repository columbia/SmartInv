1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract EduCoin is owned {
21     string public constant name = "EduCoin";
22     string public constant symbol = "EDU";
23     uint256 private constant _INITIAL_SUPPLY = 15000000000;  //初始数字货币量150亿
24     uint8 public decimals = 0;
25 
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Burn(address indexed from, uint256 value);
34    
35     function EduCoin (
36         address genesis
37     ) public {
38         owner = msg.sender;
39         require(owner != 0x0);
40         require(genesis != 0x0);
41         totalSupply = _INITIAL_SUPPLY;
42         balanceOf[genesis] = totalSupply;
43     }
44 
45     function _transfer(address _from, address _to, uint _value) internal {
46         require(_to != 0x0);
47         require(balanceOf[_from] >= _value);
48         require(balanceOf[_to] + _value > balanceOf[_to]);
49         uint previousBalances = balanceOf[_from] + balanceOf[_to];
50         balanceOf[_from] -= _value;
51         balanceOf[_to] += _value;
52         Transfer(_from, _to, _value);
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55 
56     function transfer(address _to, uint256 _value) public {
57         _transfer(msg.sender, _to, _value);
58     }
59 
60 }