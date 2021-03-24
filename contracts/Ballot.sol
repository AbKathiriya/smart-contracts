// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract Ballot {
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    address public chairPerson;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    constructor(bytes32[] memory proposalNames) {
        chairPerson = msg.sender;
        voters[chairPerson].weight = 1;

        for(uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i], 
                voteCount: 0
            }));
        }
    }

    function giveRightToVote(address voter) public {
        require(msg.sender == chairPerson, 'Only chair person can give rights to vote');
        require(!voters[voter].voted, 'You have already voted');
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, 'You have no right to vote');
        require(!sender.voted, 'You have already voted');
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;
    }

    function winningProposal() public view returns (uint _winningProposal) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if(proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                _winningProposal = p;
            }
        }
    }

    function winnerName() public view returns (bytes32 _winnerName) {
        _winnerName = proposals[winningProposal()].name;
    }

    function delegate(address to) public {
        Voter storage sender = voters[msg.sender];

        require(sender.weight != 0, 'You have no right to vote');
        require(!sender.voted, 'You have already voted');
        require(msg.sender != to, 'Self delegation is not allowed');

        while(voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(msg.sender != to, 'Loop found in self delegation');
        }

        sender.voted = true;
        sender.delegate = to;

        Voter storage _delegate = voters[to];
        if(_delegate.voted) {
            proposals[_delegate.vote].voteCount += sender.weight;
        } else {
            _delegate.weight += sender.weight;
        }
    }
}