1 pragma solidity ^0.4.18;
2 contract ERC20Interface {
3     function totalSupply() public constant returns (uint);
4     function balanceOf(address tokenOwner) public constant returns (uint balance);
5     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
6     function transfer(address to, uint tokens) public returns (bool success);
7     function approve(address spender, uint tokens) public returns (bool success);
8     function transferFrom(address from, address to, uint tokens) public returns (bool success);
9 
10     event Transfer(address indexed from, address indexed to, uint tokens);
11     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
12 }
13 
14 
15 contract TokenTimelock {
16     ERC20Interface public token;
17     // beneficiary of tokens after they are released
18     address public beneficiary;
19 
20     // timestamp when token release is enabled
21     uint256 public releaseTime;
22 
23     constructor(ERC20Interface _token, address _beneficiary, uint256 _releaseTime) public
24     {
25         // solium-disable-next-line security/no-block-members
26         require(_releaseTime > block.timestamp);
27         token = _token;
28         beneficiary = _beneficiary;
29         releaseTime = _releaseTime;
30     }
31 
32     /**
33     * @notice Transfers tokens held by timelock to beneficiary.
34     */
35     function release() public {
36         // solium-disable-next-line security/no-block-members
37         require(block.timestamp >= releaseTime);
38 
39         uint256 amount = token.balanceOf(address(this));
40         require(amount > 0);
41 
42         token.transfer(beneficiary, amount);
43     }
44 }