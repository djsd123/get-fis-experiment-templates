// package get_fis_experiment_templates
package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/fis"
	"github.com/aws/aws-sdk-go-v2/service/fis/types"
	"log"
)

func main() {
	cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion("eu-west-1"))
	if err != nil {
		log.Fatalf("unable to load SDK config, %v", err)
	}

	client := fis.NewFromConfig(cfg)

	input := fis.ListExperimentTemplatesInput{}

	var output []types.ExperimentTemplateSummary

	pages := fis.NewListExperimentTemplatesPaginator(client, &input)
	for pages.HasMorePages() {
		page, err := pages.NextPage(context.TODO())
		if err != nil {
			log.Fatalf("Unable to fetch pages: %v", err)
		}

		output = append(output, page.ExperimentTemplates...)
	}

	//for _, exp := range output {
	//	fmt.Println(exp.Tags)
	//}

	val := "fis-with"

	for _, exp := range output {
		name, ok := exp.Tags["Name"]
		if !ok {
			log.Fatalf("Key not found: %v", ok)
		}

		if name == val {
			fmt.Println(name)
		}
	}

	//input := fis.ListExperimentTemplatesInput{
	//	MaxResults: aws.Int32(20),
	//}
	//
	//res, err := client.ListExperimentTemplates(context.TODO(), &input)
	//if err != nil {
	//	log.Fatalf("Unable to list templates, %v", err)
	//}
	//
	//fmt.Println("Templates:")
	//for _, template := range res.ExperimentTemplates {
	//	//fmt.Println(*template.Id, *template.Arn, template.Tags["Name"])
	//	name, ok := template.Tags["Name"]
	//	if !ok {
	//		log.Fatalf("Key not found: %v", ok)
	//	}
	//	//fmt.Println(name, ok)
	//
	//	if name == "fis-without" {
	//		fmt.Printf("This template: %s\nHas the following ARN %s\n", name, *template.Arn)
	//	}
	//}
}

func getExperimentTemplateByNameTag(client *fis.Client, name string) *fis.GetExperimentTemplateOutput {

	inputList := fis.ListExperimentTemplatesInput{}

	respList, err := client.ListExperimentTemplates(context.TODO(), &inputList)
	if err != nil {
		log.Fatalf("Unable to list templates, %v", err)
	}

	var result *fis.GetExperimentTemplateOutput
	for _, template := range respList.ExperimentTemplates {
		if name == template.Tags["Name"] {
			inputget := fis.GetExperimentTemplateInput{
				Id: template.Id,
			}

			resp, err := client.GetExperimentTemplate(context.TODO(), &inputget)
			if err != nil {
				log.Fatalf("Unable to get template, %v", err)
			}

			result = resp
		}
	}
	return result
}
