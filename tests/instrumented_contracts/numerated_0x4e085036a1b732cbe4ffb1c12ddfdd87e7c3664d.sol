1 pragma solidity ^0.6.7;
2 
3 // SPDX-License-Identifier: No Licencse
4   
5    
6 contract Owned {
7     modifier onlyOwner() {
8         require(msg.sender==owner);
9         _;
10     }
11     address payable owner;
12    
13 }
14 
15 abstract contract ERC20 {
16     uint256 public totalSupply;
17     function balanceOf(address _owner) view public virtual returns (uint256 balance);
18     function transfer(address _to, uint256 _value) public virtual returns (bool success);
19     function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
20     function approve(address _spender, uint256 _value) public virtual returns (bool success);
21     function allowance(address _owner, address _spender) view public virtual returns (uint256 remaining);
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 }
25 
26 contract Token is Owned,  ERC20 {
27     string public symbol;
28     string public name;
29     uint8 public decimals;
30     mapping (address=>uint256) balances;
31     mapping (address=>mapping (address=>uint256)) allowed;
32     
33     function balanceOf(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}
34     
35     function transfer(address _to, uint256 _amount) public virtual override returns (bool success) {
36         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
37         balances[msg.sender]-=_amount;
38         balances[_to]+=_amount;
39         emit Transfer(msg.sender,_to,_amount);
40         return true;
41     }
42   
43     function transferFrom(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {
44         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
45         balances[_from]-=_amount;
46         allowed[_from][msg.sender]-=_amount;
47         balances[_to]+=_amount;
48         emit Transfer(_from, _to, _amount);
49         return true;
50     }
51   
52     function approve(address _spender, uint256 _amount) public virtual override returns (bool success) {
53         allowed[msg.sender][_spender]=_amount;
54         emit Approval(msg.sender, _spender, _amount);
55         return true;
56     }
57     
58     function allowance(address _owner, address _spender) view public virtual override returns (uint256 remaining) {
59       return allowed[_owner][_spender];
60     }
61 }
62 
63 contract PRDZ is Token{
64     
65     constructor() public{
66         symbol = "PRDZ";
67         name = "PRDZ Dex";
68         decimals = 18;
69         totalSupply = 30000000000000000000000;  
70         owner = msg.sender;
71         balances[owner] = totalSupply;
72     }
73     
74     receive () payable external {
75         require(msg.value>0);
76         owner.transfer(msg.value);
77     }
78 }