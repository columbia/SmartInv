1 pragma solidity ^0.7.0;
2 
3 contract Owned {
4     modifier onlyOwner() {
5         require(msg.sender == owner);
6         _;
7     }
8     address owner;
9     address newOwner;
10     function changeOwner(address payable _newOwner) public onlyOwner {
11         newOwner = _newOwner;
12     }
13     function acceptOwnership() public {
14         if (msg.sender == newOwner) {
15             owner = newOwner;
16         }
17     }
18 }
19 
20 contract ERC20 {
21     string public symbol;
22     string public name;
23     uint8 public decimals;
24     uint256 public totalSupply;
25     mapping (address=>uint256) balances;
26     mapping (address=>mapping (address=>uint256)) allowed;
27     event Transfer(address indexed _from, address indexed _to, uint256 _value);
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29     
30     function balanceOf(address _owner) view public returns (uint256 balance) {return balances[_owner];}
31     
32     function transfer(address _to, uint256 _amount) public returns (bool success) {
33         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
34         balances[msg.sender]-=_amount;
35         balances[_to]+=_amount;
36         emit Transfer(msg.sender,_to,_amount);
37         return true;
38     }
39   
40     function transferFrom(address _from,address _to,uint256 _amount) public returns (bool success) {
41         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
42         balances[_from]-=_amount;
43         allowed[_from][msg.sender]-=_amount;
44         balances[_to]+=_amount;
45         emit Transfer(_from, _to, _amount);
46         return true;
47     }
48   
49     function approve(address _spender, uint256 _amount) public returns (bool success) {
50         allowed[msg.sender][_spender]=_amount;
51         emit Approval(msg.sender, _spender, _amount);
52         return true;
53     }
54     
55     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
56       return allowed[_owner][_spender];
57     }
58 }
59 
60 contract GloxFinance  is Owned,ERC20{
61     uint256 public maxSupply;
62 
63     constructor(address _owner) {
64         symbol = "GLOX";
65         name = "Glox Finance";
66         decimals = 18;                                   // 10 Decimals
67         totalSupply = 18000000000000000000000;           // 18,000 is Total Supply ; Rest 18 Zeros are Decimals
68         maxSupply   = 18000000000000000000000;           // 18,000 is Total Supply ; Rest 18 Zeros are Decimals
69         owner = _owner;
70         balances[owner] = totalSupply;
71     }
72     
73     receive() external payable {
74         revert();
75     }
76     
77    
78 }