1 pragma solidity 0.4.20;
2 
3 contract MOREToken {
4     string  public  symbol = "MORE";
5     string  public name = "MORE Token";
6     uint256  public  decimals = 18; 
7     uint256  _supply;
8     mapping (address => uint256) _balances;
9     
10     event Transfer( address indexed from, address indexed to, uint256 value);
11 
12     function MOREToken() public {
13         _supply = 10*(10**9)*(10**18);
14         _balances[msg.sender] = _supply;
15     }
16     
17     function totalSupply() public view returns (uint256) {
18         return _supply;
19     }
20     function balanceOf(address src) public view returns (uint256) {
21         return _balances[src];
22     }
23     
24     function transfer(address dst, uint256 wad) public {
25         require(_balances[msg.sender] >= wad);
26         
27         _balances[msg.sender] = sub(_balances[msg.sender], wad);
28         _balances[dst] = add(_balances[dst], wad);
29         
30         Transfer(msg.sender, dst, wad);
31     }
32     
33     function add(uint256 x, uint256 y) internal pure returns (uint256) {
34         uint256 z = x + y;
35         require(z >= x && z>=y);
36         return z;
37     }
38 
39     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
40         uint256 z = x - y;
41         require(x >= y && z <= x);
42         return z;
43     }
44 }