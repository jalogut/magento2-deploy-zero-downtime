@title[Introduction]
## Fully automated 
## Zero downtime
##### <span style="font-family:Helvetica Neue; font-weight:bold">deployments in <span style="color:#f46f25">Magento 2.2</span></span>

---?image=assets/img/about-me.png
@title[About me]

---
@title[Agenda 0]
## Agenda

* Project Setup
* Wrong deployment
* Right deployment
* Zero Downtime
* Build Pipeline
* CI

---
@title[Agenda 1]
## Agenda

* **Project Setup**
* <span style="opacity: 0.2;">Wrong deployment</span>
* <span style="opacity: 0.2;">Right deployment</span>
* <span style="opacity: 0.2;">Zero Downtime</span>
* <span style="opacity: 0.2;">Build Pipeline</span>
* <span style="opacity: 0.2;">CI</span>

@fa[arrow-down]

+++
@title[Project Setup]

<ul>
<li>git (or another VCS)</li>
<li class="fragment">composer</li>
<li class="fragment">~~vendor~~ NOT in VCS</li>
<li class="fragment">~~etc/env.php~~  NOT in VCS</li>
<li class="fragment">etc/config.php in VCS</li>
<li class="fragment">composer.lock in VCS</li>
</ul>

+++
@title[Proper Magento 2 Composer Setup]
#### Proper Magento 2 Composer Setup

<br>

Tutorial: [https://blog.hauri.me/proper-magento2-composer-setup.html](https://blog.hauri.me/proper-magento2-composer-setup.html)

---
@title[Agenda 2]
## Agenda

* <span style="opacity: 0.2;">Project Setup</span>
* **Wrong deployment**
* <span style="opacity: 0.2;">Right deployment</span>
* <span style="opacity: 0.2;">Zero Downtime</span>
* <span style="opacity: 0.2;">Build Pipeline</span>
* <span style="opacity: 0.2;">CI</span>

@fa[arrow-down]

+++
#### Manually

<br>

[Demo]

+++
#### Manually

<br>

- Waste of time |
- Easy to make mistakes |
- High Downtime: 15min - 30min |

+++
#### Simple Automation

<br>

[Demo]

+++
#### Simple Automation

<br>

- Not reliable |
- High Downtime: 15min - 30min |

---
@title[Agenda 3]
## Agenda

* <span style="opacity: 0.2;">Project Setup</span>
* <span style="opacity: 0.2;">Wrong deployment</span>
* **Right deployment**
* <span style="opacity: 0.2;">Zero Downtime</span>
* <span style="opacity: 0.2;">Build Pipeline</span>
* <span style="opacity: 0.2;">CI</span>

@fa[arrow-down]

+++
@title[Current live]
#### Current live

<br>

![Relase Symlink](assets/img/release_symlink_1.png)

+++
@title[Deploying new version]
#### Deploying new version

<br>

![Relase Symlink](assets/img/release_symlink_2.png)

+++
@title[Switch symlink]
#### Switch symlink

<br>

![Relase Symlink](assets/img/release_symlink_3.png)

+++
@title[Shared Data]
#### Shared Data

![Shared Data](assets/img/release_symlink_4.png)

+++

@title[Tools]

#### Tools

<br>

- [Deployer (PHP)](https://deployer.org/)
- [Capistrano (Ruby)](http://capistranorb.com/)
- [Shipit-deploy (Node-js)](https://github.com/shipitjs/shipit-deploy)

+++
@title[Demo Right Deployment]

[Demo]

+++
#### Pros

<br>

- Fully automated |
- Reliable |
- Low Downtime: ~20sec |

---
@title[Disclaimer 2.2]
#### Disclaimer

<br>

##### hereafter <span style="font-family:Helvetica Neue; font-weight:bold">only version <span style="color:#f46f25">>= 2.2</span></span>

---
@title[Agenda 4]
## Agenda

* <span style="opacity: 0.2;">Project Setup</span>
* <span style="opacity: 0.2;">Wrong deployment</span>
* <span style="opacity: 0.2;">Right deployment</span>
* **Zero Downtime**
* <span style="opacity: 0.2;">Build Pipeline</span>
* <span style="opacity: 0.2;">CI</span>

@fa[arrow-down]

+++
@title[Skip Maintenance]
#### Skip Maintenance

![Skip maintenance](assets/img/skip_maintenance.png)

+++
@title[Demo zero downtime]

[Demo] 
<!--
First show in local, how the commands reacts when editing module.xml version and config.php
Later update the deploy.sh to skip maintenance
Mention that setup:upgrade always runs config:import, so if the first is needed we do not need to execute config:import again
Show PR link
-->

+++
@title[Zero downtime commands]

- setup:db:status
- config:import:status (Magento >= 2.2.3)
	- Gist with workaround

+++
@title[Zero downtime accomplished]

#### Zero Downtime accomplished!
![Emoji Rock](assets/img/emoji_rock.png)

---
@title[Agenda 5]
## Agenda

* <span style="opacity: 0.2;">Project Setup</span>
* <span style="opacity: 0.2;">Wrong deployment</span>
* <span style="opacity: 0.2;">Right deployment</span>
* <span style="opacity: 0.2;">Zero Downtime</span>
* **Build Pipeline**
* <span style="opacity: 0.2;">CI</span>

@fa[arrow-down]

+++
@titla[Build Pipeline]
#### Build Pipeline

![Build Pipeline](assets/img/build_pipeline.png)

Build: Archived artifact that can be consumed directly in different servers.

+++

#### What do we need?
Config used for Bundle same as servers

<br>

#### How?
Config Propagation

+++

#### Magento Config Propagation

<br>

- etc/config.php
- app:config:dump

+++

#### Config.php

![Config.php](assets/img/config_dump_system.png)

+++

#### app:config:dump

![Facepalm](https://media.giphy.com/media/ce1x5VblkD69i/giphy.gif)

+++

#### Up-Vote this PR! 👍

<br>

[Add argument on app:config:dump to skip dumping all system settings](https://github.com/magento/magento2/pull/12410)


+++?gist=jalogut/d72e0af6e10c502bff90423e66bf07b9&lang=xml&title=Workaround: Skip System Dump GIST

+++

#### Update config.php if changes on:

<br>

- Scopes (website, stores)
- Theme 
- Web assets config

+++

[Demo]

<!-- move to build.sh. [static-deploy -f] deploy.sh unzips only -->
<!-- scp out with command -->
<!-- mention artifact.excludes -->

+++ 

#### Why?

<br>

- Save CPU during deployment
- Identify file generation issues right away |
- Common bundle to share amongst Envs |
- History for auditing or back in time checks | 

---
@title[Agenda 6]
## Agenda

* <span style="opacity: 0.2;">Project Setup</span>
* <span style="opacity: 0.2;">Wrong deployment</span>
* <span style="opacity: 0.2;">Right deployment</span>
* <span style="opacity: 0.2;">Zero Downtime</span>
* <span style="opacity: 0.2;">Build Pipeline</span>
* **CI**

+++

#### One system for all

<br>

Automatically: Tests -> builds -> deploys

+++
@title[Jenkins Tutorial]
####Jenkins tutorial

<br>

Jenkins Tutorial[https://dev.to/jalogut](https://dev.to/jalogut)

<span style="font-size:0.6em; color:gray">Setup Continuos Integration/Delivery system in just 4 steps with Jenkins Pipelines and Blue Ocean</span>

+++?code=https://github.com/jalogut/magento-2.2-demo/blob/master/Jenkinsfile&lang=groovy&title=Source: Jenkinsfile

@[10-12,13,16](Get project and execute tests)
@[29-32](Build Bundle)
@[34-36](Always deploy Develop)
@[40,42,50,56](Confirm and deploy to Stage/Production)

+++?code=scripts/build-jenkins/build&lang=bash&title=Source: build

@[22-24](Git clone not needed. Jenkins gets it automatically)

+++?code=scripts/build-deploy/deploy.sh&lang=bash&title=Source: deploy.sh

@[33-34](Timestamp name for develop releases)

+++
@title[Jenkins Video]

![YouTube Video](https://www.youtube.com/embed/qxPEcCca9tk)

---
@title[Tips]
## Tips

+++

#### TIPS!

* build and deploy in a repo, so you share it among all projects. Only properties on the project level. (show how to move the properties)
* (db backup before setup:upgrade)
* disable modules if needed
* clean up old releases and backups
* release unique name for develop branch, if we want to continuously update our dev server with the latest status of develop
* cron:update

+++

#### TIPS!

magento2-deployment-tool

+++

Learn more: 
- Deploy.php
- Mage2Deploy
- https://info2.magento.com/rs/585-GGD-959/images/The%20New%20Magento%202.2%20Deployment%20Capabilities%20%26%20Patterns.pdf

---
@title[Issues]

#### Issues and Workarounds!

* config:import:dump (gist until PR approved)
* config:import:status (workaroung until PR approved)
* Local $_ENV for urls and shared settings
* static-deploy language command one by one
* static-deploy options not working
* Rollbacks
* Cache clear -> sudo service php5-fpm reload && varnish
* Disable module if installed in required-dev

---
@title[Take aways]
## Take Aways

<br>

- Start easy, if you do not have a build system. Just deploy w/o it. You can reliable deploy with Zero downtime
- If you have a CI in place, try the new build pipeline
- If issues arise, create a PR and be patient (Magento is not perfect)
- Do not use the demo bash scripts. I created them only for the demo. Now that you know how the deployments should work, use your favourite tool to implement that
- No excuses for not automated deployments (You have seen how simple it is to accomplish zero downtime by using bash scripts. So even if that is not the best way, you do not have any excuses to not automate your deployments)



---
@title[thank you]

##Thanks

 