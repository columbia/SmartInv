1 contract ERC20Basic {
2   function totalSupply() public view returns (uint256);
3   function balanceOf(address who) public view returns (uint256);
4   function transfer(address to, uint256 value) public returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 contract ERC20 is ERC20Basic {
8   function allowance(address owner, address spender) public view returns (uint256);
9   function transferFrom(address from, address to, uint256 value) public returns (bool);
10   function approve(address spender, uint256 value) public returns (bool);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 contract TokenDistribution {
14     function distribute(ERC20 token, address[] destinations, uint[] amounts) public {
15         require(destinations.length == amounts.length);
16         uint total;
17         uint i;
18         for (i = 0; i < destinations.length; i++) total += amounts[i];
19         require(token.transferFrom(msg.sender, this, total));
20         for (i = 0; i < destinations.length; i++) require(token.transfer(destinations[i], amounts[i]));
21     }
22 }