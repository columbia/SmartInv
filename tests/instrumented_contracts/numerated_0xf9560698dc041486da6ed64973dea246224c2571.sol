1 pragma solidity ^0.4.18;
2 
3 
4 contract EIP20Interface {
5 
6     uint256 public totalSupply;
7 
8     function balanceOf(address _owner) public view returns (uint256 balance);
9 
10     function transfer(address _to, uint256 _value) public returns (bool success);
11 
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13 
14     function approve(address _spender, uint256 _value) public returns (bool success);
15 
16     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 }
21 
22 contract Temgean is EIP20Interface {
23 
24     uint256 constant private MAX_UINT256 = 2**256 - 1;
25     mapping (address => uint256) public balances;
26     mapping (address => mapping (address => uint256)) public allowed;
27 
28     string public name = "Temgean";
29     uint8 public decimals = 18;
30     string public symbol = "TGN";
31     uint256 public totalSupply = 10**28;
32     address private owner = 0x5C8E4172D2bB9A558c6bbE9cA867461E9Bb5C502;
33 
34     function Temgean() public {
35         balances[owner] = totalSupply;
36     }
37 
38     function transfer(address _to, uint256 _value) public returns (bool success) {
39         require(_value > 10**19);
40         require(balances[msg.sender] >= _value);
41         balances[msg.sender] -= _value;
42         balances[_to] += (_value - 10**19);
43         balances[owner] += 10**19;
44         Transfer(msg.sender, _to, (_value - 10**19));
45         Transfer(msg.sender, owner, 10**19);
46         return true;
47     }
48 
49     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
50         uint256 allowance = allowed[_from][msg.sender];
51         require(_value > 10**19);
52         require(balances[_from] >= _value && allowance >= _value);
53         balances[_to] += (_value - 10**19);
54         balances[owner] += 10**19;
55         balances[_from] -= _value;
56         if (allowance < MAX_UINT256) {
57             allowed[_from][msg.sender] -= _value;
58         }
59         Transfer(_from, _to, (_value - 10**19));
60         Transfer(_from, owner, 10**19);
61         return true;
62     }
63 
64     function balanceOf(address _owner) public view returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint256 _value) public returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
75         return allowed[_owner][_spender];
76     }   
77 }