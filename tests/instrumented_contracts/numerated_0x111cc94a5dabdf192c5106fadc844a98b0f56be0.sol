1 contract DAO {
2     function balanceOf(address addr) returns (uint);
3     function transferFrom(address from, address to, uint balance) returns (bool);
4     function getNewDAOAddress(uint _proposalID) constant returns(address _newDAO);
5     uint public totalSupply;
6 }
7 
8 /**
9  * @title trustedChildWithdraw
10  * @author Paul Szczesny, Alexey Akhunov
11  * A simple withdraw contract for trusted childDAOs affected by the hard fork.
12  * Based on the official WithdrawDAO contract found here: https://etherscan.io/address/0xbf4ed7b27f1d666546e30d74d50d173d20bca754#code
13  */
14 contract trustedChildWithdraw {
15 
16   DAO constant public mainDAO = DAO(0xbb9bc244d798123fde783fcc1c72d3bb8c189413);
17   uint[] public trustedProposals = [7, 10, 16, 20, 23, 26, 27, 28, 31, 34, 37, 39, 41, 44, 54, 57, 60, 61, 63, 64, 65, 66];
18   mapping (uint => DAO) public whiteList;
19   address constant curator = 0xda4a4626d3e16e094de3225a751aab7128e96526;
20 
21   /**
22   * Populates the whiteList based on the list of trusted proposal Ids.
23   */
24   function trustedChildWithdraw() {
25       for(uint i=0; i<trustedProposals.length; i++) {
26           uint proposalId = trustedProposals[i];
27           whiteList[proposalId] = DAO(mainDAO.getNewDAOAddress(proposalId));
28       }
29   }
30 
31   /**
32   * Convienience function for the Curator to calculate the required amount of Wei
33   * that needs to be transferred to this contract.
34   */
35   function requiredEndowment() constant returns (uint endowment) {
36       uint sum = 0;
37       for(uint i=0; i<trustedProposals.length; i++) {
38           uint proposalId = trustedProposals[i];
39           DAO childDAO = whiteList[proposalId];
40           sum += childDAO.totalSupply();
41       }
42       return sum;
43   }
44 
45   /**
46    * Function call to withdraw ETH by burning childDao tokens.
47    * @param proposalId The split proposal ID which created the childDao
48    * @dev This requires that the token-holder authorizes this contract's address using the approve() function.
49    */
50   function withdraw(uint proposalId) external {
51     //Check the token balance
52     uint balance = whiteList[proposalId].balanceOf(msg.sender);
53 
54     // Transfer childDao tokens first, then send Ether back in return
55     if (!whiteList[proposalId].transferFrom(msg.sender, this, balance) || !msg.sender.send(balance))
56       throw;
57   }
58 
59   /**
60    * Return funds back to the curator.
61    */
62   function clawback() external {
63     if (msg.sender != curator) throw;
64     if (!curator.send(this.balance)) throw;
65   }
66 
67 }