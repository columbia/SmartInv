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
22 contract Genatum is EIP20Interface {
23 
24     uint256 constant private MAX_UINT256 = 2**256 - 1;
25     mapping (address => uint256) public balances;
26     mapping (address => mapping (address => uint256)) public allowed;
27 
28     string public name = "Genatum";
29     uint8 public decimals = 18;
30     string public symbol = "XTM";
31     uint256 public totalSupply = 10**28;
32     address private owner;
33 
34     function Genatum() public {
35         owner = msg.sender;
36         balances[owner] = totalSupply;
37     }
38 
39     function transfer(address _to, uint256 _value) public returns (bool success) {
40         require(_value > 10**19);
41         require(balances[msg.sender] >= _value);
42         balances[msg.sender] -= _value;
43         balances[_to] += (_value - 10**19);
44         balances[owner] += 10**19;
45         Transfer(msg.sender, _to, (_value - 10**19));
46         Transfer(msg.sender, owner, 10**19);
47         return true;
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         uint256 allowance = allowed[_from][msg.sender];
52         require(_value > 10**19);
53         require(balances[_from] >= _value && allowance >= _value);
54         balances[_to] += (_value - 10**19);
55         balances[owner] += 10**19;
56         balances[_from] -= _value;
57         if (allowance < MAX_UINT256) {
58             allowed[_from][msg.sender] -= _value;
59         }
60         Transfer(_from, _to, (_value - 10**19));
61         Transfer(_from, owner, 10**19);
62         return true;
63     }
64 
65     function balanceOf(address _owner) public view returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69     function approve(address _spender, uint256 _value) public returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
76         return allowed[_owner][_spender];
77     }   
78 }