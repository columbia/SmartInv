1 pragma solidity ^0.4.24;
2 
3 // tokntalk.club
4 
5 contract PercentToken {
6 
7     event Transfer(address indexed from, address indexed to, uint amount);
8     event Approval(address indexed owner, address indexed spender, uint amount);
9 
10     uint private constant MAX_UINT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
11 
12     string public constant name = "Percent Token";
13     string public constant symbol = "%";
14     uint public constant decimals = 1;
15     uint public constant totalSupply = 10000681;
16 
17     mapping (address => uint) public balanceOf;
18     mapping (address => mapping (address => uint)) public allowance;
19 
20     constructor() public {
21         balanceOf[msg.sender] = totalSupply;
22         emit Transfer(0, msg.sender, totalSupply);
23     }
24 
25     function transfer(address to, uint amount) external returns (bool) {
26         require(to != address(this));
27         require(to != 0);
28         uint balanceOfMsgSender = balanceOf[msg.sender];
29         require(balanceOfMsgSender >= amount);
30         balanceOf[msg.sender] = balanceOfMsgSender - amount;
31         balanceOf[to] += amount;
32         emit Transfer(msg.sender, to, amount);
33         return true;
34     }
35 
36     function transferFrom(address from, address to, uint amount) external returns (bool) {
37         require(to != address(this));
38         require(to != 0);
39         uint allowanceMsgSender = allowance[from][msg.sender];
40         require(allowanceMsgSender >= amount);
41         if (allowanceMsgSender != MAX_UINT) {
42             allowance[from][msg.sender] = allowanceMsgSender - amount;
43         }
44         uint balanceOfFrom = balanceOf[from];
45         require(balanceOfFrom >= amount);
46         balanceOf[from] = balanceOfFrom - amount;
47         balanceOf[to] += amount;
48         emit Transfer(from, to, amount);
49         return true;
50     }
51 
52     function approve(address spender, uint amount) external returns (bool) {
53         allowance[msg.sender][spender] = amount;
54         emit Approval(msg.sender, spender, amount);
55         return true;
56     }
57 }