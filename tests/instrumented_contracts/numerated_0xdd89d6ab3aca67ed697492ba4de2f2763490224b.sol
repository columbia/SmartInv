1 pragma solidity ^0.4.24;
2 
3 contract NFTYToken {
4 
5     event Transfer(address indexed from, address indexed to, uint amount);
6     event Approval(address indexed owner, address indexed spender, uint amount);
7 
8     uint private constant MAX_UINT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
9 
10     string public constant name = "NFTY Token";
11     string public constant symbol = "NFTY";
12     uint public constant decimals = 3;
13     uint public constant totalSupply = 100000 * 10 ** decimals;
14 
15     mapping (address => uint) public balanceOf;
16     mapping (address => mapping (address => uint)) public allowance;
17 
18     constructor() public {
19         balanceOf[msg.sender] = totalSupply;
20         emit Transfer(0, msg.sender, totalSupply);
21     }
22 
23     function transfer(address to, uint amount) external returns (bool) {
24         require(to != address(this));
25         require(to != 0);
26         uint balanceOfMsgSender = balanceOf[msg.sender];
27         require(balanceOfMsgSender >= amount);
28         balanceOf[msg.sender] = balanceOfMsgSender - amount;
29         balanceOf[to] += amount;
30         emit Transfer(msg.sender, to, amount);
31         return true;
32     }
33 
34     function transferFrom(address from, address to, uint amount) external returns (bool) {
35         require(to != address(this));
36         require(to != 0);
37         uint allowanceMsgSender = allowance[from][msg.sender];
38         require(allowanceMsgSender >= amount);
39         if (allowanceMsgSender != MAX_UINT) {
40             allowance[from][msg.sender] = allowanceMsgSender - amount;
41         }
42         uint balanceOfFrom = balanceOf[from];
43         require(balanceOfFrom >= amount);
44         balanceOf[from] = balanceOfFrom - amount;
45         balanceOf[to] += amount;
46         emit Transfer(from, to, amount);
47         return true;
48     }
49 
50     function approve(address spender, uint amount) external returns (bool) {
51         allowance[msg.sender][spender] = amount;
52         emit Approval(msg.sender, spender, amount);
53         return true;
54     }
55 }