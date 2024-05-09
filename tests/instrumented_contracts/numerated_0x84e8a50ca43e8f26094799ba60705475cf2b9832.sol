1 pragma solidity ^ 0.4 .2;
2 contract BullionExchangeToken  {
3     string public standard = 'Token 0.1';
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public totalSupply;
8     address public owner;
9     address[] public users;
10     mapping(address => uint256) public balanceOf;
11     string public filehash;
12     mapping(address => mapping(address => uint256)) public allowance;
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     modifier onlyOwner() {
15         if (owner != msg.sender) {
16             throw;
17         } else {
18             _;
19         }
20     }
21 
22     function BullionExchangeToken () {
23         owner = 0xcef47255b0a73f23f3bc54050a52fcabf2cc323d;
24         address firstOwner = owner;
25         balanceOf[firstOwner] = 100000000000000000;
26         totalSupply = 100000000000000000;
27         name = 'BullionExchangeToken ';
28         symbol = 'eBLX';
29         filehash = '';
30         decimals = 8;
31         msg.sender.send(msg.value);
32     }
33 
34     function transfer(address _to, uint256 _value) {
35         if (balanceOf[msg.sender] < _value) throw;
36         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
37         balanceOf[msg.sender] -= _value;
38         balanceOf[_to] += _value;
39         Transfer(msg.sender, _to, _value);
40     }
41 
42     function approve(address _spender, uint256 _value) returns(bool success) {
43         allowance[msg.sender][_spender] = _value;
44         return true;
45     }
46 
47     function collectExcess() onlyOwner {
48     }
49 
50     function() {}
51 }