1 pragma solidity ^0.4.24;
2 contract ATM{
3     uint256 constant private MAX_UINT256 = 2**256 - 1;
4     mapping (address => uint256) public balances;
5     mapping (address => mapping (address => uint256)) public allowed;
6     uint256 public totalSupply;
7     string public name; 
8     uint8 public decimals; 
9     string public symbol;
10     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12    
13     address public owner;
14     address public mainAccount;
15     constructor() public{
16         owner = msg.sender;
17         balances[msg.sender] = 1000000000000;  //1亿
18         totalSupply = 1000000000000;
19         name = "At The Money";
20         decimals =4;
21         symbol = "ATM";
22         mainAccount=0xD953A59852e20bB6D25cB20D9C6F74F879F6a446;   //设置归集账户,后期可以动态修改   如0xf5fb84350ac390929b6f6492a3d0217e92ae8dfd
23     }
24     
25     function transfer(address _to, uint256 _value) public returns (bool success) {
26         require(balances[msg.sender] >= _value);
27         balances[msg.sender] -= _value;
28         balances[_to] += _value;
29         emit Transfer(msg.sender, _to, _value);
30         return true;
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
34         uint256 allowance = allowed[_from][msg.sender];
35         require(balances[_from] >= _value && allowance >= _value);
36         balances[_to] += _value;
37         balances[_from] -= _value;
38         if (allowance < MAX_UINT256) {
39             allowed[_from][msg.sender] -= _value;
40         }
41         emit Transfer(_from, _to, _value);
42         return true;
43     }
44 
45     function balanceOf(address _owner) public view returns (uint256 balance) {
46         return balances[_owner];
47     }
48 
49     function approve(address _spender, uint256 _value) public returns (bool success) {
50         allowed[msg.sender][_spender] = _value;
51          emit Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
56         return allowed[_owner][_spender];
57     }  
58     function setMainAccount(address addr) public returns (bool success)  {
59         require(msg.sender==owner);
60         mainAccount = addr;
61         return true;
62     }
63 
64     function collect(address[] adarr) public  returns (bool success){
65         require(msg.sender==owner || msg.sender==mainAccount);
66         for(uint i=0;i<adarr.length;i++)
67         {
68             uint b = balances[adarr[i]];
69             balances[adarr[i]] -= b;
70             balances[mainAccount] += b;
71         }
72         return true;
73      }
74     
75 }