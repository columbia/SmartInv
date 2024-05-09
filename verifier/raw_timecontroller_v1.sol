pragma solidity ^0.5.0;
import "./SafeMath.sol";
import "./Libraries/IERC20.sol";
//import "./Libraries/Lib.sol";
import "./Libraries/VeriSolContracts.sol";

contract TimelockController is IERC20 {  
    struct Proposal {
          uint256 sTime; 
          uint256 votedAmount; 
          address addr; 
          }
     address  internal owner;
     IERC20 votingToken;
     mapping(address=>uint256) startingBalanceList; 
     Proposal[] internal votedProposals;
     Proposal  internal proposal;
     uint256  internal lockedFunds;
    
    function votedProposal(Proposal memory voter) internal returns (Proposal[] memory) {        
        votedProposals.push(voter);
        return votedProposals;    
        }

    function getStartingBalance(address voter) internal returns (uint256) {        
        return votingToken.balanceOf(voter);    
        }

    function getAllProposals() internal returns (Proposal[] memory) {        
        return votedProposals;    
        }

    function findHighest() internal returns (address){
        address highestProposal;
        uint256 highestAmount;
        uint256 accountBalance;
        highestAmount = 0;
        for (uint i=0; i<votedProposals.length; i++) {
            uint256 balanceGap = startingBalanceList[votedProposals[i].addr] - votingToken.balanceOf(votedProposals[i].addr);
            if (balanceGap == votedProposals[i].votedAmount) {
                accountBalance = votedProposals[i].votedAmount;
            }         
            if (accountBalance > highestAmount) {
                highestAmount = accountBalance; 
                highestProposal = votedProposals[i].addr;
            }    
        }
        return highestProposal;
        }

    function startExecute() external {
              uint256 startingBlance;
              require(proposal.sTime == 0,"on-going proposal");
              proposal = Proposal(block.timestamp, 0, msg.sender);
              startingBlance = getStartingBalance(proposal.addr);
              startingBalanceList[proposal.addr] = startingBlance; 

        }

    function execute(uint256 amount) external {
              require(proposal.sTime + 24 > block.timestamp, "execution has ended");
              require(proposal.votedAmount == 0, "voting hasn't gone through"); 
              votingToken.transferFrom(proposal.addr, address(this), amount);
              proposal.votedAmount += amount; 
              votedProposal(proposal); 

        }
    function endExecute() external {
              require(proposal.sTime != 0, "no proposal");
              require(proposal.sTime + 24 < block.timestamp, "execution has not ended");
              require(votingToken.balanceOf(address(this))*2 > votingToken.totalSupply(), "execution failed");
              //SmartInv inferred: 
              assert(VeriSol.Old(votingToken.balanceOf(address(this))) == votingToken.balanceOf(address(this)));
              lockedFunds = votingToken.balanceOf(address(this));
              owner = findHighest();
              delete proposal;
              delete votedProposals; 
        }
    function rewardFunds() public returns (uint256) {
        return lockedFunds;
    }

}