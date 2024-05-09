1 /**
2  *
3  * Time-locked ETH vault of money being transferred into team multisig.
4  *
5  * Add 4 weeks delay to the transfer to the team multisig wallet.
6  *
7  * The owning party can reset the timer.
8  *
9  */
10 contract IntermediateVault  {
11 
12   /** Interface flag to determine if address is for a real contract or not */
13   bool public isIntermediateVault = true;
14 
15   /** Address that can claim tokens */
16   address public teamMultisig;
17 
18   /** UNIX timestamp when tokens can be claimed. */
19   uint256 public unlockedAt;
20 
21   event Unlocked();
22   event Paid(address sender, uint amount);
23 
24   function IntermediateVault(address _teamMultisig, uint _unlockedAt) {
25 
26     teamMultisig = _teamMultisig;
27     unlockedAt = _unlockedAt;
28 
29     // Sanity check
30     if(teamMultisig == 0x0)
31       throw;
32 
33     // Do not check for the future time here, so that test is easier.
34     // Check for an empty value though
35     // Use value 1 for testing
36     if(_unlockedAt == 0)
37       throw;
38   }
39 
40   /// @notice Transfer locked tokens to Lunyr's multisig wallet
41   function unlock() public {
42     // Wait your turn!
43     if(now < unlockedAt) throw;
44 
45     // StandardToken will throw in the case of transaction fails
46     if(!teamMultisig.send(address(this).balance)) throw; // Should this forward gas, since we trust the wallet?
47 
48     Unlocked();
49   }
50 
51   function () public payable {
52     // Collect deposits from the crowdsale
53     Paid(msg.sender, msg.value);
54   }
55 
56 }