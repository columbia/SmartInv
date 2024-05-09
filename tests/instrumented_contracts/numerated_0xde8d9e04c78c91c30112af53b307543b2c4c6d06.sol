1 pragma solidity 0.4.23;
2 
3 contract ERC20BasicInterface {
4     function balanceOf(address _owner) public view returns (uint256 balance);
5     function transfer(address _to, uint256 _value) public returns (bool success);
6 }
7 
8 /**
9  * @title ERC20Lock
10  *
11  * This contract keeps particular token till the unlock date and sends it to predefined destination.
12  */
13 contract DLSDLockAdvisors3 {
14     ERC20BasicInterface constant TOKEN = ERC20BasicInterface(0x8458d484572cEB89ce70EEBBe17Dc84707b241eD);
15     address constant OWNER = 0x603F65F7Fc4f650c2F025800F882CFb62BF23580;
16     address constant DESTINATION = 0x309F0716701f346F2aE84ec9a45ce7E69E747f18;
17     uint constant UNLOCK_DATE = 1548547199; // Saturday, January 26, 2019 11:59:59 PM
18 
19     function unlock() public returns(bool) {
20         require(now > UNLOCK_DATE, 'Tokens are still locked');
21         return TOKEN.transfer(DESTINATION, TOKEN.balanceOf(address(this)));
22     }
23 
24     function recoverTokens(ERC20BasicInterface _token, address _to, uint _value) public returns(bool) {
25         require(msg.sender == OWNER, 'Access denied');
26         // This token meant to be recovered by calling unlock().
27         require(address(_token) != address(TOKEN), 'Can not recover this token');
28         return _token.transfer(_to, _value);
29     }
30 }