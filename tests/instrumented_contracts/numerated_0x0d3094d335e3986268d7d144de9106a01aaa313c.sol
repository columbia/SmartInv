1 contract ERC20Basic {
2   uint public totalSupply;
3   function balanceOf(address who) constant returns (uint);
4   function transfer(address to, uint value);
5   event Transfer(address indexed from, address indexed to, uint value);
6 }
7 
8 contract ERC20 is ERC20Basic {
9   function allowance(address owner, address spender) constant returns (uint);
10   function transferFrom(address from, address to, uint value);
11   function approve(address spender, uint value);
12   event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 
16 contract MultiSender {
17 
18     function multisend(address _tokenAddr, address[] dests, uint256[] values)
19     returns (uint256) {
20         uint256 i = 0;
21         while (i < dests.length) {
22            ERC20(_tokenAddr).transfer(dests[i], values[i]);
23            i += 1;
24         }
25         return(i);
26     }
27 }