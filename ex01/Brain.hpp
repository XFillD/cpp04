#include <string>
#include <iostream>

class Brain
{
	private:
		std::string _ideas[100];

	public:
		Brain();
		Brain(const Brain &copyBrain);

		virtual ~Brain();

		Brain &operator=(const Brain &brain);

		const std::string getIdea(size_t i)const;
		const std::string *getIdeaAddress(size_t i)const;

		void setIdea(size_t i, std::string idea);
};