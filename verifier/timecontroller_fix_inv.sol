pragma solidity ^0.5.0;
import "./SafeMath.sol";
import "./Libraries/IERC20.sol";
import "./Libraries/VeriSolContracts.sol";




contract TimelockController is IERC20 {  
     address  internal owner; //owner of this contract
     uint256 public startTime; //starting time of a proposal
     mapping(address=>uint256) startingBalanceList; //starting balance of each address
     address[] internal voteAddrList; //address that has voted (called execute function)
     mapping(address => bool) public existingAddr; //existing voted address to prevent double voting
     uint256 internal lockedFunds; //locked funds in this contract 
     IERC20 votingToken; //votingToken to make a transfer

    
    function getStartingBalance(address voter) internal view returns (uint256) {        
        return votingToken.balanceOf(voter);    
        }

    function findHighest() internal view returns (address) {
        address highestProposal;
        uint256 highestAmount;
        uint256 balanceGap;

        highestAmount = 0; 
        for (uint i=0; i<voteAddrList.length; i++) {
            balanceGap = startingBalanceList[voteAddrList[i]] - votingToken.balanceOf(voteAddrList[i]);
            require(balanceGap >= 0, "negative voting amount!");
            if (balanceGap > highestAmount) {
                highestAmount = balanceGap;
                highestProposal = voteAddrList[i];
                }    
            }
        require(highestProposal!=address(0), "no address found!");
        return highestProposal;
        }

    function startExecute() external payable {
        require(startTime==0,"on-going proposal");
        startTime = block.timestamp; //execute a proposal round at current blocktime
        }


    function execute(uint256 amount) external payable {
        require(existingAddr[msg.sender]!=true, "address has voted already."); //check if an address has voted 
        require(startTime + 24*60*60 > block.timestamp, "execution has ended."); //check if 24 hours has passed
        startingBalanceList[msg.sender] = getStartingBalance(msg.sender); //find the current balance of msg.sender, comment out this line to prevent gas-related in REMIX 
        votingToken.transferFrom(msg.sender, address(this), amount); 
        voteAddrList.push(msg.sender);
        existingAddr[msg.sender] = true;
        }

    function endExecute() external payable {
        require(startTime != 0, "no proposal.");
        require(startTime + 24*60*60 < block.timestamp, "execution has not ended.");
        require(votingToken.balanceOf(address(this))*2 > votingToken.totalSupply(), "execution failed");
        //SmartInv inferred: 
        assert(VeriSol.Old(votingToken.balanceOf(address(this))) == votingToken.balanceOf(address(this)));
        lockedFunds = votingToken.balanceOf(address(this)); //comment out this line to prevent gas-related in REMIX 
        owner = findHighest();
        if (votingToken.approve(owner, lockedFunds) == true) {
            votingToken.transfer(owner, lockedFunds); 
        }
        lockedFunds = 0; 
        delete voteAddrList; 
        }
}