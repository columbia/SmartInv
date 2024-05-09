1 pragma solidity ^0.4.24;
2 
3 contract OwnerHelper
4 {
5     address public owner;
6 
7     event OwnerTransferPropose(address indexed _from, address indexed _to);
8 
9     modifier onlyOwner
10     {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     constructor() public
16     {
17         owner = msg.sender;
18     }
19 
20     function transferOwnership(address _to) onlyOwner public
21     {
22         require(_to != owner);
23         require(_to != address(0x0));
24         owner = _to;
25         emit OwnerTransferPropose(owner, _to);
26     }
27 }
28 
29 contract Token {
30     bytes32 public standard;
31     bytes32 public name;
32     bytes32 public symbol;
33     uint256 public totalSupply;
34     uint8 public decimals;
35     bool public allowTransactions; 
36     mapping (address => uint256) public balanceOf;
37     mapping (address => mapping (address => uint256)) public allowance;
38     function transfer(address _to, uint256 _value) public returns (bool success);
39     function approve(address _spender, uint256 _value) public returns (bool success);
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
41 }
42 
43 contract TokenDistribute is OwnerHelper
44 {
45     uint public E18 = 10 ** 18;
46 
47     constructor() public
48     {
49     }
50     
51     function multipleTokenDistribute(address _token, address[] _addresses, uint[] _values) public onlyOwner
52     {
53         for(uint i = 0; i < _addresses.length ; i++)
54         {
55             Token(_token).transfer(_addresses[i], _values[i] * E18);  
56         }
57     }
58 }