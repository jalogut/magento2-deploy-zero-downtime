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
<li class="fragment">composer.lock in VCS</li>
<li class="fragment">etc/config.php in VCS</li>
<li class="fragment">~~etc/env.php~~  **NOT** in VCS</li>
<li class="fragment">~~vendor~~ **NOT** in VCS</li>
</ul>

+++
@title[Composer Setup Tutorial]
#### Tutorial

<br>

Proper Magento 2 Composer Setup: [https://blog.hauri.me/](https://blog.hauri.me/proper-magento2-composer-setup.html)

+++
@title[Magento 2 Project Example]
#### Example

<br>

Magento 2.2 demo: [https://github.com/jalogut/magento-2.2-demo](https://github.com/jalogut/magento-2.2-demo)

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
@title[Zero downtime commands]

- setup:db:status
- config:import:status (Magento >= 2.2.3)
	- Gist with workaround

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
@title[Build Pipeline]

![Build Pipeline](assets/img/build_pipeline.png)

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

@fa[arrow-down]

+++

#### One system for all

<br>

Automatically: Tests -> builds -> deploys

+++
@title[Jenkins Tutorial]
#### Jenkins tutorial

<br>

Setup Continuos Integration/Delivery system: [https://dev.to/jalogut](https://dev.to/jalogut/setup-continuos-integrationdelivery-system-in-just-4-steps-with-jenkins-pipelines-and-blue-ocean)

+++?code=scripts/build-jenkins/build.sh&lang=bash&title=Source: Jenkins build.sh

@[17-18](Properties and excludes project specific)
@[25-28](Git clone not needed. Jenkins gets it automatically)

+++?code=scripts/build-deploy/deploy.sh&lang=bash&title=Source: deploy.sh

@[33-35](Timestamp name for develop releases)

+++
@title[Jenkins project example]
#### Jenkins Example

[https://github.com/jalogut/magento-2.2-demo](https://github.com/jalogut/magento-2.2-demo)
![Jenking project example](assets/img/jenkins_project_example.png)

+++?code=scripts/build-jenkins/Jenkinsfile&lang=groovy&title=Source: Jenkinsfile

@[10-12,13,16](Get project and execute tests)
@[29-32](Build Bundle)
@[33-38](Always deploy Develop)
@[40-42,49-50,55-56](Confirm and deploy to Stage/Production)

+++
@title[Jenkins Video]

![YouTube Video](https://www.youtube.com/embed/qxPEcCca9tk)

---
@title[Tips]
## Tips

+++
@title[Composer Tweaks]

<p><span class="menu-title slide-title">Source: Composer.json</span></p>

```json
  "config": {
    "preferred-install": {
      "<your_vendor>/*": "source",
      "*": "dist"
    }
  },

```

`composer install --no-dev --prefer-dist`

`--prefer-dist` caches better.

+++

Also use `--optimize-autoloader` for servers. It generates autoloader faster. Do not use in development.

`composer install --no-dev --prefer-dist --optimize-autoloader`

+++

#### Composer parallel downloads

`composer global require hirak/prestissimo`

+++
#### Update crontab automatically

`bin/magento cron:install --force`

di.xml
```xml
<type name="Magento\Framework\Crontab\TasksProviderInterface">
    <arguments>
        <argument name="tasks" xsi:type="array">
            <item name="CUSTOM_CRON" xsi:type="array">
                <item name="expression" xsi:type="string">0 3 * * *</item>
                <item name="command" xsi:type="string">{magentoRoot}bin/magento custom:command</item>
            </item>
        </argument>
    </arguments>
</type>
```

+++ 
#### Static Files Strategies

[http://devdocs.magento.com/guides/v2.2/config-guide/cli/config-cli-subcommands-static-deploy-strategies.html](http://devdocs.magento.com/guides/v2.2/config-guide/cli/config-cli-subcommands-static-deploy-strategies.html)

- Standard
- Quick
- Compact

According to docs:

`bin/magento setup:static-content:deploy -f --strategy compact`
-> 3 locales x2 faster; 15 locales x10 faster – due to less disk I/O

**Warning**: I did not test it yet.

+++

#### DB Backup 

<p><span class="menu-title slide-title">Source: deploy.sh</span></p>
```bash
if [[ 1 == ${UPGRADE_NEEDED} ]]; then
  	bin/magento maintenance:enable
  	${LIVE}/${MAGERUN_BIN} db:dump --compression='gzip' ${WORKING_DIR}/backups/live-$(date +%s).sql.gz
  	bin/magento setup:upgrade --keep-generated
fi
```

+++
#### Use Tools

<br>
All this OUT-OF-THE-BOX

[magento2-builder-tool](https://github.com/staempfli/magento2-builder-tool)
[magento2-deployment-tool](https://github.com/staempfli/magento2-deployment-tool)

Example: [magento-22-mg2-builder](https://github.com/jalogut/magento-22-mg2-builder)

---
@title[Issues]

#### Issues and Workarounds!

* restart fpm after release `sudo service php5-fpm reload`

+++

* config:import:dump (gist until PR approved)

+++

* Local $_ENV for urls and shared settings

+++

* static-deploy language command one by one
* static-deploy options not working

+++

* Rollbacks

<!-- * While rare, Rollback are sometimes needed. You can automate that although I would not recomend it. It is always better to release a new hotfix version than rolling back. Anyway, if for any reason you need to do it, you need to:
    * Check setup:upgrade and config:import:status. If green then switch symlinks and update caches. 
    * If red, enable maintenance, setup_modules back or config:import, switch, clear cache and disable maintenance. -->

---
@title[Take aways]
## Take Aways

<br>

- Start easy, you can accomplish 0 downtime even w/o a build system (very convenient for small project w/o autatic tests) |
- Build pipeline if a step forward for better deployment strategies |
- App:config commands are not mature yet. |
- Pipeline issues, create a PR and be patient (Magento is not perfect) |
- Automate your deployments using a tool. Bash scripts were only for the demo |


–––
@title[Resources]
#### Resources

Learn more: 

- Deploy.php
- Mage2Deploy
- https://info2.magento.com/rs/585-GGD-959/images/The%20New%20Magento%202.2%20Deployment%20Capabilities%20%26%20Patterns.pdf

+++
#### Presentation source

Slides: [https://gitpitch.com/jalogut/magento2-deploy-zero-downtime](https://gitpitch.com/jalogut/magento2-deploy-zero-downtime)

Scripts: [https://github.com/jalogut/magento2-deploy-zero-downtime/tree/master/scripts](https://github.com/jalogut/magento2-deploy-zero-downtime/tree/master/scripts)

Project Example: [https://github.com/jalogut/magento-2.2-demo](https://github.com/jalogut/magento-2.2-demo)


---
@title[thank you]

##Thanks

 