# Use an official Python runtime as a parent image
FROM python:3.6

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app
	
# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

# Install CPLEX solver
RUN chmod +x cplex_studio128.linux-x86-64.bin
RUN ./cplex_studio128.linux-x86-64.bin -f ./response.properties
RUN cd /opt/ibm/ILOG/CPLEX_Studio128/cplex/python/3.6/x86-64_linux/ && python ./setup.py install

#RUN wget http://github.com/bbuchfink/diamond/releases/download/v0.9.25/diamond-linux64.tar.gz
#RUN tar xzf diamond-linux64.tar.gz

COPY diamond /usr/bin/
RUN chmod +x /usr/bin/diamond

RUN rm diamond
RUN rm cplex_studio128.linux-x86-64.bin

RUN carveme_init

EXPOSE 8888

ENTRYPOINT ["jupyter", "notebook","--ip=0.0.0.0","--allow-root","--NotebookApp.token='davedemo'"]