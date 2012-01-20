Gitcycle
========

Tame your development cycle.

Get Started
-----------

Visit [gitcycle.com](http://gitcycle.com) to set up your environment.

Create Branch
-------------

Checkout the branch that you will eventually merge your feature into:

	git checkout master

Type `gitc` + your ticket URL to create a new branch:

	gitc https://xxx.lighthouseapp.com/projects/0000/tickets/0000-my-ticket

Pull Changes from Upstream
--------------------------

When you're developing, you may need to pull new changes from the upstream branch that you will eventually merge your feature into:

	gitc pull

Discuss Code
------------

After pushing one or two commits, put the code up for discussion:

	gitc discuss

Mark as Ready
-------------

When the branch is ready for merging, mark it as ready:

	gitc ready

This will mark the pull request as "Pending Review".

Code Review
-----------

Managers will periodically check for "Pending Review" issues on GitHub.

Once reviewed, they will mark the issue as reviewed:

	gitc reviewed 0000

Where 0000 is the Github issue number.

Quality Assurance
-----------------

QA engineers will periodically check for "Pending QA" issues on Github.

To create a new QA branch:

	gitc qa 0000 0001

This will create a new QA branch containing the commits from the related Github issue numbers.

This branch can be deployed to a staging environment for QA.

QA Fail
-------

If a feature does not pass QA:

	gitc qa fail 0000

Where 0000 is the Github issue number.

To fail all issues:

	gitc qa fail

This will add a "fail" label to the issue.

QA Pass
------- 

If a feature passes QA:

	gitc qa pass 0000

Where 0000 is the Github issue number.

To pass all issues:

	gitc qa pass

This will add a "pass" label to the issue and will complete the pull request by merging the feature branch into the target branch.

Todo
----

* Make ticket active when starting branch
* Label issues with ticket milestone?
* Check for conflict whenever merge happens
* Instead of detecting CONFLICT, use error status $? != 0
* Add comment on lighthouse with issue URL