FROM ubuntu:latest

MAINTAINER Mark Fernandes <mark.fernandes@ifr.ac.uk>

ENV SIAB_VERSION=2.19 \
  SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00+Black-on-White.css,Reverse:-/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css" \
  SIAB_PORT=4200 \
  SIAB_ADDUSER=true \
  SIAB_USER=guest \
  SIAB_USERID=1000 \
  SIAB_GROUP=guest \
  SIAB_GROUPID=1000 \
  SIAB_PASSWORD=putsafepasswordhere \
  SIAB_SHELL=/bin/bash \
  SIAB_HOME=/home/guest \
  SIAB_SUDO=false \
  SIAB_SSL=true \
  SIAB_SERVICE=/:LOGIN \
  SIAB_PKGS=none \
  SIAB_SCRIPT=none

ENV DOCS=$SIAB_HOME/docs DATA=$SIAB_HOME/data WORK=$SIAB_HOME/work SIAB_USER=ngsintro SIAB_GROUP=ngs_group

USER root

# need fastqc, samtools bwa bowtie picard-tools GATK jre wget git
RUN apt-get install -y software-properties-common && \
    add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu precise universe" && \
    add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu precise main restricted universe multiverse" && \
    add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu precise-updates main restricted universe multiverse" && \
    add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu precise-backports main restricted universe multiverse" && \
    apt-get update && apt-get -y install bowtie bwa curl default-jre fastqc git gzip monit openssh-client openssl picard-tools \
    poppler-utils samtools shellinabox wget && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  ln -sf '/etc/shellinabox/options-enabled/00+Black on White.css' \
    /etc/shellinabox/options-enabled/00+Black-on-White.css && \
  ln -sf '/etc/shellinabox/options-enabled/00_White On Black.css' \
    /etc/shellinabox/options-enabled/00_White-On-Black.css && \
  ln -sf '/etc/shellinabox/options-enabled/01+Color Terminal.css' \
    /etc/shellinabox/options-enabled/01+Color-Terminal.css


RUN mkdir SSIAB_HOME/course && mkdir $DOCS && mkdir $DATA && mkdir $WORK
# RUN wget http://xoanon.cf.ac.uk/rpi/GenomeAnalysisTK.jar

# Paper & course notes(pdf) use less to read from command-line
# RUN wget -O paper.pdf $DOCS http://f1000research.com/articles/1-2/v2/pdf
# RUN wget -O NGS_tutorial.pdf http://www.walesgenepark.cardiff.ac.uk/wp-content/uploads/2013/04/1.1-Introductory-NGS.pdf
ADD Docs\* $DOCS
ADD Data\* $DATA
ADD GenomeAnalysisTK.jar course
ADD Welcome.txt /etc/motd

# Description of reads data
# https://figshare.com/collections/Simulated_Illumina_BRCA1_reads_in_FASTQ_format/1641980
# obtain reads that we will be using for analysis exercises
#wget http://files.figshare.com/92198/Brca1Reads_1.1.fastq
#wget http://files.figshare.com/92203/Brca1Reads_1.2.fastq
# Download entire set of reads as zip archive
# https://ndownloader.figshare.com/articles/92338/versions/1
# download read sets from f1000 cloud (S3) volume
# RUN wget -O $DATA/Reads_1.1.fastq https://s3-eu-west-1.amazonaws.com/pstorage-f1000-a46686352/92198/Brca1Reads_1.1.fastq
# RUN wget -O $DATA/Reads_1.2.fastq https://s3-eu-west-1.amazonaws.com/pstorage-f1000-a46686352/92203/Brca1Reads_1.2.fastq

#RUN useradd --create-home --shell /bin/bash --user-group --uid 1000 --groups sudo ngsintro && \
#    echo `echo "ngsintro\nngsintro\n" | passwd ngsintro`

# RUN groupadd -r $GALAXY_USER -g $GALAXY_GID && \
#    useradd -u $GALAXY_UID -r -g $GALAXY_USER -d $GALAXY_HOME -c "Galaxy user" $GALAXY_USER && \
#    mkdir $EXPORT_DIR $GALAXY_HOME && chown -R $GALAXY_USER:$GALAXY_USER $GALAXY_HOME $EXPORT_DIR && \
#    gpasswd -a $GALAXY_USER docker
# ADD ./bashrc $GALAXY_HOME/.bashrc

RUN chown -R ngsintro:ngsintro $SIAB_HOME/course

EXPOSE 22
EXPOSE 4200
	
#USER ngsintro

#CMD ["/usr/sbin/sshd", "-D"]
# CMD /usr/bin/sshd && tail -F /var/log/cont.log
# CMD ["/usr/local/bin/monit","-D"]
#CMD /bin/bash

VOLUME /etc/shellinabox /var/log/supervisor /home

ADD assets/entrypoint.sh /usr/local/sbin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["shellinabox"]



