1 pragma solidity 0.5.1;
2 
3 /// @title birthday.sol -- A birthday card for a special person.
4 /// @author Preston Van Loon <preston@prysmaticlabs.com>
5 contract BirthdayCard {
6     event PassphraseOK(string passphrase);
7     
8     string public message;
9     
10     bytes32 hashed_passphrase;
11     ERC20 constant dai = ERC20(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
12     
13     /// @dev Initialize the contract
14     /// @param _message to write inside of the birthday card
15     /// @param _hashed_passphrase is the keccak256 hashed passphrase
16     constructor(string memory _message, bytes32 _hashed_passphrase) public {
17         message = _message;
18         hashed_passphrase = _hashed_passphrase;
19     }
20     
21     /// @dev Withdraw the DAI and selfdestruct this birthday card!
22     /// Just like real life: take the money out and throw the card away!!
23     /// @param passphrase is the secret to test.
24     function withdraw(string memory passphrase) public {
25         require(isPassphrase(passphrase));
26         emit PassphraseOK(passphrase);
27         
28         assert(dai.transfer(msg.sender, dai.balanceOf(address(this))));
29         selfdestruct(msg.sender);
30     }
31 
32     /// @dev How much money is inside of this birthday card? 
33     /// Divide the result of this by 10^18 to get the DAI dollar amount.
34     function balanceOf() public view returns (uint) {
35         return dai.balanceOf(address(this));
36     }
37     
38     /// @dev Sanity check for the passphrase before sending the transaction.
39     /// @param passphrase is the secret to test.
40     function isPassphrase(string memory passphrase) public view returns (bool) {
41         return keccak256(bytes(passphrase)) == hashed_passphrase;
42     }
43 }
44 
45 
46 /// erc20.sol -- API for the ERC20 token standard
47 
48 // See <https://github.com/ethereum/EIPs/issues/20>.
49 contract ERC20Events {
50     event Approval(address indexed src, address indexed guy, uint wad);
51     event Transfer(address indexed src, address indexed dst, uint wad);
52 }
53 
54 contract ERC20 is ERC20Events {
55     function totalSupply() public view returns (uint);
56     function balanceOf(address guy) public view returns (uint);
57     function allowance(address src, address guy) public view returns (uint);
58 
59     function approve(address guy, uint wad) public returns (bool);
60     function transfer(address dst, uint wad) public returns (bool);
61     function transferFrom(
62         address src, address dst, uint wad
63     ) public returns (bool);
64 }