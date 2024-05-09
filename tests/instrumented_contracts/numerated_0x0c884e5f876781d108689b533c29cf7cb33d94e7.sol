1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4     function totalSupply() constant public returns (uint256 supply);
5     function balanceOf(address _owner) constant public returns (uint balance);
6     function transfer(address _to, uint _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
8     function approve(address _spender, uint _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public returns (uint remaining);
10     event Transfer(address _from, address _to, uint _value);
11     event Approval(address _owner, address _spender, uint _value);
12 }
13 
14 contract Token is ERC20 {
15     string public symbol;
16     string public name;
17     uint8 public decimals;
18     uint256 public totalSupply;
19 	address public owner;
20     mapping (address=>uint256) balances;
21     mapping (address=>mapping (address=>uint256)) allowed;
22     
23     function totalSupply() constant public returns (uint256 supply) {
24         supply = totalSupply;
25     }
26     function balanceOf(address _owner) constant public returns (uint256 balance) {return balances[_owner];}
27     
28     function transfer(address _to, uint256 _amount) public returns (bool success) {
29         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
30         balances[msg.sender]-=_amount;
31         balances[_to]+=_amount;
32         emit Transfer(msg.sender,_to,_amount);
33         return true;
34     }
35   
36     function transferFrom(address _from,address _to,uint256 _amount) public returns (bool success) {
37         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
38         balances[_from]-=_amount;
39         allowed[_from][msg.sender]-=_amount;
40         balances[_to]+=_amount;
41         emit Transfer(_from, _to, _amount);
42         return true;
43     }
44   
45     function approve(address _spender, uint256 _amount) public returns (bool success) {
46         allowed[msg.sender][_spender]=_amount;
47         emit Approval(msg.sender, _spender, _amount);
48         return true;
49     }
50     
51     function allowance(address _owner, address _spender) public returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 }
55 
56 contract GDC is Token{
57 	modifier onlyOwner() {
58       if (msg.sender!=owner) revert();
59       _;
60     }
61     
62     constructor() public{
63         symbol = "GDC";
64         name = "GOLDENCOIN";
65         decimals = 4;
66         totalSupply = 2000000000000;
67         owner = msg.sender;
68         balances[owner] = totalSupply;
69     }
70     
71     function transferOwnership(address newOwner) public onlyOwner {
72         require (newOwner!=0);
73         owner = newOwner;
74     }
75     
76     function () payable public {
77         revert();
78     }
79 }