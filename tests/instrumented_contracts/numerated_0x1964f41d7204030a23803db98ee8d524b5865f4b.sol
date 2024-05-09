1 pragma solidity ^0.4.19;
2 
3 /* Function required from ERC20 main contract */
4 contract TokenERC20 {
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {}
6 }
7 
8 contract MultiSend {
9     TokenERC20 public _ERC20Contract;
10     address public _multiSendOwner;
11     
12     function MultiSend () {
13         address c = 0xc3761EB917CD790B30dAD99f6Cc5b4Ff93C4F9eA; // set ERC20 contract address
14         _ERC20Contract = TokenERC20(c); 
15         _multiSendOwner = msg.sender;
16     }
17     
18     /* Make sure you allowed this contract enough ERC20 tokens before using this function
19     ** as ERC20 contract doesn't have an allowance function to check how much it can spend on your behalf
20     ** Use function approve(address _spender, uint256 _value)
21     */
22     function dropCoins(address[] dests, uint256 tokens) {
23         require(msg.sender == _multiSendOwner);
24         uint256 amount = tokens;
25         uint256 i = 0;
26         while (i < dests.length) {
27             _ERC20Contract.transferFrom(_multiSendOwner, dests[i], amount);
28             i += 1;
29         }
30     }
31     
32 }